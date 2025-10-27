# Eliyana LMS Platform — Software Requirements Specification (SRS)

## 1. Introduction

### 1.1 Purpose
This document specifies the functional and non-functional requirements for the Eliyana LMS Platform, a branded evolution of the open-source Frappe Learning application. It translates the Business Requirements Document (BRD) into implementation-ready guidance for engineering, quality assurance, and operations teams supporting the pilot release on Frappe Cloud and future self-hosted deployments.

### 1.2 Scope
The platform couples a Frappe backend application (`lms` package) with a Vue 3 single-page frontend (`frontend` directory) to deliver structured learning, assessments, billing, AI-assisted coaching, and a built-in jobs marketplace. It covers configuration, integrations, telemetry, and deployment automation relevant to the Eliyana Ventures product vision.

### 1.3 Product Overview
* Backend: Frappe DocTypes, controllers, and API endpoints governing courses, batches, lessons, certifications, payments, jobs, and telemetry.
* Frontend: Vite-powered SPA using Vue 3, Pinia, TailwindCSS, Frappe UI components, Socket.IO, and Editor.js to render learner and admin experiences.
* Operations: Docker scripts, bench automation, and production entrypoints enabling managed and self-hosted environments.

### 1.4 Definitions, Acronyms, Abbreviations
* **AI Copilot:** In-product assistant offering contextual explanations, drafting, localization, course search, and assignment coaching.
* **Batch/Cohort:** Grouped learner enrollment associated with a course run.
* **DocType:** Frappe metadata describing data models and associated logic.
* **Job Opportunity / LMS Job Application:** Frappe DocTypes powering the integrated jobs marketplace.
* **Quick Win:** Actionable deliverable template demonstrating learner outcomes within 14 days.
* **RAG:** Retrieval-Augmented Generation, the mechanism for the Copilot's "Search My Course" feature.

### 1.5 References
* `docs/BRD.md` — Business Requirements Document.
* Repository `README.md` — deployment and contribution guidance.
* `pyproject.toml`, `package.json` — backend and frontend dependency manifests.

## 2. Overall Description

### 2.1 Product Perspective
The LMS is a vertical Frappe application that runs within a Frappe Bench context. The backend exposes REST-like whitelisted methods consumed by the Vue SPA through Frappe UI resources. The AI Copilot layers on top using server-side retrieval endpoints and external LLM providers. The jobs marketplace reuses Frappe's website routing to list opportunities under `/lms/job-openings` while keeping application flows within the SPA shell.

### 2.2 Product Functions
* Author, manage, and deliver courses, lessons, cohorts, and assessments.
* Track learner progress, certifications, and Quick Win submissions.
* Provide AI Copilot assistance with localized drafting, explanations, course-aware search, and assignment coaching.
* Publish and manage job opportunities, accept applications, and report on hiring outcomes.
* Integrate Eventbrite and Canva intake pipelines for lead ingestion and auto-enrollment.
* Enforce billing validation for paid offerings using Frappe Payments.
* Capture telemetry, analytics, and cost metrics for product performance.

### 2.3 User Classes and Characteristics
* **System Managers:** Configure site settings, payments, telemetry, AI provider credentials, and oversee deployments.
* **Instructors / Course Creators:** Create courses, batches, assignments, Quick Win templates, and associated job postings.
* **Mentors / Moderators / Evaluators:** Approve cohort requests, review submissions, evaluate assignments, and interact with job applicants.
* **Learners (Founders / MSMEs):** Consume content, leverage the Copilot, submit assignments, apply for jobs, and provide feedback.
* **Operations & Support:** Monitor integrations, manage onboarding pipelines, and maintain employer relationships for job listings.

### 2.4 Operating Environment
* **Managed Pilot:** Hosted on Frappe Cloud with managed benches/sites, SSL, and FC APIs for lifecycle automation.
* **Self-Hosted:** Docker-based benches or manual Frappe benches on cloud infrastructure (AWS, DigitalOcean) post-pilot.
* **Backend Stack:** Python ≥3.10, MariaDB, Redis, Node assets compiled via Frappe, background workers, Socket.IO server.
* **Frontend Stack:** Node ≥16, Vite build pipeline, Yarn/npm, served as `/lms` assets bundled into the Frappe site.

### 2.5 Design and Implementation Constraints
* AGPL-3.0 licensing; derivative works must remain compliant.
* SPA router base `/lms`, aligning with Frappe website routing and authentication.
* Payments limited to gateways supported by the Frappe Payments app.
* AI Copilot must adhere to human-in-the-loop and data minimization policies (90-day retention, redaction of PII).
* Jobs module must leverage existing DocTypes to retain compatibility with upstream Frappe LMS updates.

### 2.6 Assumptions and Dependencies
* Frappe authentication (sessions/cookies) is available to gate routes and API calls.
* External AI provider credentials are provisioned securely and can meet latency/cost targets.
* Employers provide job details compliant with Frappe DocType schemas.
* Eventbrite and Canva integrations supply webhook payloads with sufficient data for lead creation.
* DNS/TLS managed by Frappe Cloud during pilot; self-hosted deployments follow documented practices.

## 3. System Features

### 3.1 Course Authoring and Catalog Management
1. **[F-01]** Support hierarchical course structures with chapters and lessons, including ordering, metadata, and SEO fields.
2. **[F-02]** Auto-generate unique slugs for courses, lessons, and batches to power SPA routing.
3. **[F-03]** Validate instructor assignments, certification toggles, pricing, and publication states before allowing courses to go live.
4. **[F-04]** Expose course catalog listings and filters through `/lms/courses`, honoring guest access settings.

### 3.2 Lesson Delivery and Learner Progress
1. **[F-05]** Render lessons via SPA routes with sequential navigation, SCORM support, and assignment access.
2. **[F-06]** Persist learner progress, resume states, and Quick Win completion markers across devices.
3. **[F-07]** Derive lesson icons/types from Editor.js content blocks or macros for consistent UI cues.
4. **[F-08]** Provide downloadable resources and localization-ready copy within lesson views.

### 3.3 Cohorts, Batches, and Live Classes
1. **[F-09]** Manage cohort enrollment via invite codes and mentor approvals, preventing duplicate requests.
2. **[F-10]** Surface batch schedules, live class links, and attendance tracking through SPA components.
3. **[F-11]** Notify instructors/mentors of pending join requests and upcoming live sessions.

### 3.4 Assessments, Assignments, and Quick Wins
1. **[F-12]** Allow instructors to create quizzes, assignments, and Quick Win templates using Frappe DocTypes.
2. **[F-13]** Enable learners to submit responses, drafts, and attachments with autosave and history views.
3. **[F-14]** Route submissions to evaluators for manual review and scoring, capturing structured feedback.

### 3.5 Certification and Badging
1. **[F-15]** Issue completion certificates and paid certificate variants with verification URLs.
2. **[F-16]** Track certificate purchases and ensure payment verification via Frappe Payments where applicable.

### 3.6 AI Copilot Experience
1. **[F-17]** Provide Copilot states: closed → floating button → expanded drawer (30–40% width) → full-screen overlay.
2. **[F-18]** Implement Explain Lesson, Draft (≤120 words), Localise (English/Swahili/Shona), Search My Course with RAG + citations, and Assignment Coach tools.
3. **[F-19]** Maintain per-lesson interaction history, accessible even after navigation within the same lesson context.
4. **[F-20]** Enforce refusal messaging for unsafe or out-of-scope prompts and record interactions for analytics within privacy constraints.
5. **[F-21]** Monitor latency (target <2s first token, <8s p90 completion) and cost per interaction (≤$0.08 average during pilot).

### 3.7 Jobs Marketplace and Career Services
1. **[F-22]** Publish job opportunities via Frappe `Job Opportunity` DocType with company branding, location, category, and course alignment metadata.
2. **[F-23]** Display jobs on `/lms/job-openings` with search and filter capabilities, supporting guest viewing while prompting login for applications.
3. **[F-24]** Allow authenticated learners to submit `LMS Job Application` records with resume uploads, cover notes, and consent flags.
4. **[F-25]** Provide dashboards or reports summarizing application counts, statuses, and hires to instructors and ops.
5. **[F-26]** Link job recommendations within course or Quick Win views based on tags or learning tracks.

### 3.8 Integrations and Automation
1. **[F-27]** Consume Eventbrite and Canva webhooks to upsert leads/users, auto-enroll in designated courses/batches, and trigger welcome emails.
2. **[F-28]** Log integration events, expose retry options, and alert admins on failures.
3. **[F-29]** Support optional zero-rated or reverse-billed access by flagging cohorts and capturing partner metadata.

### 3.9 Billing and Monetization
1. **[F-30]** Validate eligibility for paid courses, cohorts, or certificates before initiating payments.
2. **[F-31]** Restrict access to paid resources until payment confirmation is received.

### 3.10 Notifications and Communication
1. **[F-32]** Use Frappe notifications/queues to inform learners of cohort approvals, upcoming live sessions, Quick Win feedback, and job application updates.
2. **[F-33]** Alert admins at 80% of AI Copilot budget thresholds and integration errors.

### 3.11 Telemetry, Analytics, and Reporting
1. **[F-34]** Capture activation funnel metrics, Copilot usage (interactions, helpfulness scores, cost), Quick Win completion, conversion, retention, and job application outcomes.
2. **[F-35]** Send PostHog events (prefixed `lms_`) conditioned on telemetry settings; disable gracefully when not configured.
3. **[F-36]** Provide exportable reports or API endpoints for downstream analytics.

## 4. External Interface Requirements

### 4.1 User Interfaces
* Vue SPA served at `/lms`, responsive layouts, accessible via keyboard and screen readers.
* Copilot UI integrated as a side panel/drawer overlay that can go full-screen without breaking core layout.
* Job listings integrated within SPA and website context, consistent with Eliyana branding.

### 4.2 API Interfaces
* Frappe whitelisted endpoints (REST-like) for courses, cohorts, lessons, translations, telemetry, jobs, and applications.
* Custom endpoints for Copilot retrieval, interaction logging, and integration webhooks.

### 4.3 Data Interfaces
* MariaDB tables backing DocTypes for courses, lessons, batches, Quick Wins, jobs, and applications.
* File storage for lesson assets, resumes, and certificate templates via Frappe's file system or S3-compatible storage.
* Redis queues for background jobs (notifications, data sync, AI requests if proxied through workers).

### 4.4 Integration Interfaces
* Eventbrite/Canva webhook endpoints with shared secrets for verification.
* External AI provider APIs (e.g., OpenAI, Anthropic) with streaming response support.
* PostHog ingestion API for telemetry events.

## 5. Non-Functional Requirements

### 5.1 Security
* Enforce authentication on restricted routes; require login for job applications and paid content.
* Apply role-based permissions on DocTypes controlling course publishing, job postings, and application review.
* Redact PII from Copilot logs; store AI interaction data for ≤90 days.
* Ensure TLS via Frappe Cloud certificates or managed certificates in self-hosted environments.

### 5.2 Performance
* SPA routes should load within 3 seconds on 3G-class networks; use lazy-loaded modules where possible.
* Copilot streaming responses must initiate within 2 seconds for the 50th percentile and 5 seconds for the 90th percentile.
* Jobs listing queries should return within 1 second for typical result sets.

### 5.3 Reliability and Availability
* Pilot SLO: 99% uptime per month on Frappe Cloud.
* Provide automated database backups (daily) and file backups aligned with Frappe Cloud/Self-hosted policies.
* Implement retry logic for integration webhooks and AI requests.

### 5.4 Maintainability
* Follow linting/formatting (Ruff, isort, Prettier/Tailwind) to maintain code hygiene.
* Encapsulate Copilot services, job marketplace extensions, and integration handlers in dedicated modules to ease upgrades from upstream Frappe LMS.
* Document configuration steps in `docs/` and inline README files.

### 5.5 Internationalization
* Support Swahili and Shona localization for lessons, Copilot outputs, and UI strings; rely on Frappe translation framework and frontend i18n utilities.
* Allow manual override of translations where automated localization is insufficient.

### 5.6 Telemetry and Analytics
* Configure PostHog project keys via `LMS Settings`; disable features gracefully when keys absent.
* Aggregate Copilot cost metrics (tokens × provider rate) and expose budget utilization dashboards.
* Track job application funnels (views → applications → hires) to inform MSME impact reporting.

### 5.7 Accessibility and UX
* Ensure keyboard focus management for the Copilot panel, modal dialogs, and job application forms.
* Provide ARIA labels for interactive components and ensure color contrast meets WCAG AA.
* Optimize pages for low data usage (image compression, deferred analytics scripts).

## 6. Deployment and Environment Considerations

### 6.1 Pilot Deployment on Frappe Cloud
* Use FC APIs/webhooks for site provisioning, updates, and telemetry collection.
* Configure branding, AI credentials, payment settings, and job marketplace defaults via install scripts or fixtures.
* Monitor resource utilization (CPU, memory, worker queues) to ensure Copilot load does not degrade base LMS performance.

### 6.2 Migration to Self-Hosted Infrastructure
* Provide Docker Compose and bench scripts (`docker/`, `ops/`) for AWS/DigitalOcean deployments.
* Detail environment variables for AI credentials, storage endpoints (S3/Spaces), SMTP, and analytics in documentation.
* Establish logging/monitoring stack (e.g., Prometheus + Grafana or provider equivalent) before migration.

### 6.3 Development and Testing Environments
* Support local development via Frappe bench or Docker Compose, with sample data and job postings for QA.
* Maintain Cypress E2E tests covering onboarding, Copilot interactions, and job application flows.
* Provide fixtures or scripts to seed Quick Wins, job opportunities, and course content for repeatable testing.

## 7. Appendices

### 7.1 Traceability Matrix (Excerpt)
| BRD Requirement | SRS Feature IDs |
|-----------------|-----------------|
| Copilot panel usability | F-17, F-18, F-19, F-21 |
| Quick Win impact tracking | F-12, F-13, F-34 |
| Jobs marketplace outcomes | F-22 – F-26, F-34, F-35 |
| Integration automation | F-27 – F-29 |
| Cost control & alerts | F-20, F-21, F-33 |

### 7.2 Future Enhancements (Post V1)
* Advanced Copilot tooling (auto-grading, extended localization) pending validation of pilot metrics.
* Employer self-service dashboards for job posting analytics.
* Expanded payment options tailored to regional gateways.

### 7.3 Document Control
* **Version:** 1.0
* **Last Updated:** 2025-10-27
* **Owner:** Eliyana Ventures Engineering
* **Review Cycle:** Quarterly or upon major feature changes.
