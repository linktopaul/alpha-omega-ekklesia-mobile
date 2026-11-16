-- =============================================================================
-- Alpha Omega Ekklesia Mobile — Option 1: Supabase PostgreSQL + Storage Schema
-- Church: Alpha Omega Ekklesia (Chennai, Tamil Nadu, India)
-- Senior Pastors (Super Bosses): Pastor Larry Joshua Augustus & Pastor Soma Augustus
-- =============================================================================

-- Enable UUID extension
create extension if not exists "pgcrypto";

-- -----------------------------------------------------------------------------
-- 1. FAMILIES & PASTORAL APPROVAL TABLE (aoe_families)
-- -----------------------------------------------------------------------------
create table if not exists public.aoe_families (
  family_id text primary key,                -- e.g. 'AOE-FAM-2026-001'
  family_name text not null,                 -- e.g. 'The Fernandez Family'
  head_of_household text not null,
  phone text not null,
  area_location text not null default 'Chennai, TN',
  status text not null default 'PENDING_APPROVAL'
    check (status in ('PENDING_APPROVAL', 'APPROVED')),
  approved_by_pastor text,                   -- 'Pastor Larry Joshua Augustus' or 'Pastor Soma Augustus'
  approved_at timestamptz,
  household_members jsonb not null default '[]'::jsonb, -- [{sub_id, name, relation, fellowship_group}]
  created_at timestamptz not null default now()
);

-- -----------------------------------------------------------------------------
-- 2. THE 7 OFFICIAL FELLOWSHIP GROUPS (aoe_fellowship_groups)
-- -----------------------------------------------------------------------------
create table if not exists public.aoe_fellowship_groups (
  group_id text primary key,                 -- 'AOE-GRP-01' .. 'AOE-GRP-07'
  group_number int not null unique,          -- 1 .. 7
  name text not null,
  schedule text not null,
  venue text not null,
  admin_name text not null,
  admin_member_id text not null,
  super_bosses text not null default 'Pastor Larry Joshua Augustus & Pastor Soma Augustus',
  created_at timestamptz not null default now()
);

-- -----------------------------------------------------------------------------
-- 3. FELLOWSHIP GROUP MEMBERSHIPS & APPROVALS (aoe_group_memberships)
-- -----------------------------------------------------------------------------
create table if not exists public.aoe_group_memberships (
  id uuid primary key default gen_random_uuid(),
  group_id text not null references public.aoe_fellowship_groups(group_id) on delete cascade,
  member_name text not null,
  member_sub_id text not null,               -- e.g. 'AOE-FAM-2026-002-C1'
  role text not null default 'MEMBER'
    check (role in ('SUPER_BOSS', 'GROUP_ADMIN', 'MEMBER')),
  status text not null default 'PENDING'
    check (status in ('PENDING', 'APPROVED')),
  approved_by text,                          -- Group Admin or Super Boss Pastor
  requested_at timestamptz not null default now(),
  approved_at timestamptz
);

-- -----------------------------------------------------------------------------
-- 4. WHATSAPP-STYLE FELLOWSHIP GROUP CHAT MESSAGES (aoe_group_messages)
-- -----------------------------------------------------------------------------
create table if not exists public.aoe_group_messages (
  id uuid primary key default gen_random_uuid(),
  group_id text not null references public.aoe_fellowship_groups(group_id) on delete cascade,
  sender_name text not null,
  sender_role text not null default 'MEMBER'
    check (sender_role in ('SUPER_BOSS', 'GROUP_ADMIN', 'MEMBER')),
  sender_family_id text not null,
  message_text text not null,
  shared_link_url text,
  shared_link_title text,
  reactions jsonb not null default '{}'::jsonb, -- {"Amen": 12, "Praise": 8}
  is_pinned boolean not null default false,
  created_at timestamptz not null default now()
);

-- -----------------------------------------------------------------------------
-- 5. BIRTHDAYS, ANNIVERSARIES & BAPTISM REMINDERS + WISHES (aoe_celebrations)
-- -----------------------------------------------------------------------------
create table if not exists public.aoe_celebrations (
  id text primary key,
  category text not null check (category in ('birthday', 'anniversary', 'baptism')),
  celebrant_name text not null,
  family_id text not null,
  date_badge text not null,
  milestone_title text not null,
  scripture_note text not null,
  wish_count int not null default 0,
  wishes jsonb not null default '[]'::jsonb, -- [{sender_name, sender_role, message, time_ago}]
  created_at timestamptz not null default now()
);

-- -----------------------------------------------------------------------------
-- 6. AI MULTIMODAL BETA FEEDBACK & OWNER REVIEW QUEUE (aoe_beta_feedback_queue)
-- -----------------------------------------------------------------------------
create table if not exists public.aoe_beta_feedback_queue (
  id text primary key,                       -- e.g. 'AOE-BETA-001'
  submitter_name text not null,
  submitter_role text not null,
  family_id text not null,
  module_name text not null,
  target_file text not null,
  -- Voice Note Storage Metadata (Bucket: aoe-beta-voice-notes)
  voice_file_name text not null,
  voice_storage_url text,
  voice_duration text not null,
  voice_transcript text not null,
  -- Screenshot Storage Metadata (Bucket: aoe-beta-screenshots)
  screenshot_file_name text not null,
  screenshot_storage_url text,
  screenshot_visual_analysis text not null,
  -- Gemini Multimodal LLM Synthesized GitHub Issue Draft
  issue_title text not null,
  issue_category text not null default 'enhancement'
    check (issue_category in ('enhancement', 'bug', 'ui-ux')),
  priority text not null default 'P1'
    check (priority in ('P0', 'P1', 'P2')),
  acceptance_criteria jsonb not null default '[]'::jsonb,
  -- Owner Approval Gate -> GitHub Issues
  status text not null default 'PENDING_REVIEW'
    check (status in ('PENDING_REVIEW', 'APPROVED_GITHUB', 'REJECTED')),
  github_issue_number int,
  github_issue_url text,
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz
);

-- -----------------------------------------------------------------------------
-- 7. SUPABASE STORAGE BUCKETS FOR VOICE NOTES (.m4a) & SCREENSHOTS (.png)
-- -----------------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('aoe-beta-voice-notes', 'aoe-beta-voice-notes', true, 15728640, array['audio/mp4', 'audio/m4a', 'audio/aac', 'audio/mpeg', 'audio/wav']),
  ('aoe-beta-screenshots', 'aoe-beta-screenshots', true, 10485760, array['image/png', 'image/jpeg', 'image/webp'])
on conflict (id) do nothing;

-- -----------------------------------------------------------------------------
-- 8. ROW LEVEL SECURITY (RLS) & REALTIME PUBLICATIONS
-- -----------------------------------------------------------------------------
alter table public.aoe_families enable row level security;
alter table public.aoe_fellowship_groups enable row level security;
alter table public.aoe_group_memberships enable row level security;
alter table public.aoe_group_messages enable row level security;
alter table public.aoe_celebrations enable row level security;
alter table public.aoe_beta_feedback_queue enable row level security;

-- Beta Testing Policies (Allow authenticated & anon beta testers to read/write during beta)
create policy "Beta read/write aoe_families" on public.aoe_families for all using (true) with check (true);
create policy "Beta read/write aoe_fellowship_groups" on public.aoe_fellowship_groups for all using (true) with check (true);
create policy "Beta read/write aoe_group_memberships" on public.aoe_group_memberships for all using (true) with check (true);
create policy "Beta read/write aoe_group_messages" on public.aoe_group_messages for all using (true) with check (true);
create policy "Beta read/write aoe_celebrations" on public.aoe_celebrations for all using (true) with check (true);
create policy "Beta read/write aoe_beta_feedback_queue" on public.aoe_beta_feedback_queue for all using (true) with check (true);

-- Seed the 7 Official Fellowship Groups
insert into public.aoe_fellowship_groups (group_id, group_number, name, schedule, venue, admin_name, admin_member_id)
values
  ('AOE-GRP-01', 1, 'Sunday School', 'Sundays · 09:45 AM IST', 'Children Ministry Hall', 'Lorraine Fernandez', 'AOE-FAM-2026-002-S1'),
  ('AOE-GRP-02', 2, 'Men''s Fellowship', '1st & 3rd Saturdays · 06:30 PM IST', 'Main Sanctuary', 'Desmond Fernandez', 'AOE-FAM-2026-002-H1'),
  ('AOE-GRP-03', 3, 'Women''s Fellowship', '2nd & 4th Saturdays · 04:30 PM IST', 'Prayer Hall', 'Patricia D''Cruz', 'AOE-FAM-2026-003-S1'),
  ('AOE-GRP-04', 4, 'Couple''s Fellowship', 'Last Friday Monthly · 07:00 PM IST', 'Fellowship Lounge', 'Collin Rozario', 'AOE-FAM-2026-004-H1'),
  ('AOE-GRP-05', 5, 'Choir Group', 'Saturdays · 05:00 PM IST', 'Choir Loft & Sanctuary', 'Aaron Fernandez', 'AOE-FAM-2026-002-C1'),
  ('AOE-GRP-06', 6, 'Media Team', 'Sundays · 08:45 AM IST', 'AV & Livestream Desk', 'Trevor D''Monte', 'AOE-FAM-2026-005-H1'),
  ('AOE-GRP-07', 7, 'Youth Fellowship', 'Saturdays · 05:00 PM IST', 'Youth Hall', 'Melissa D''Cruz', 'AOE-FAM-2026-003-C1')
on conflict (group_id) do nothing;
