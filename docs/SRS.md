# Eliyana LMS Platform — Software Requirements Specification (SRS)

## 1. Introduction

### 1.1 Purpose
This Software Requirements Specification (SRS) defines the functional and non-functional requirements for the Eliyana LMS Platform. It translates the strategic objectives captured in the Business Requirements Document (BRD) into detailed engineering expectations so delivery teams can implement, test, and maintain the platform consistently.

### 1.2 Scope
The Eliyana LMS Platform extends the open-source Frappe Learning foundation with localized instructional experiences, an embedded AI Copilot, integrations that automate learner onboarding, analytics for growth and impact measurement, and a curated jobs marketplace that connects graduates with MSME-friendly opportunities.

### 1.3 Definitions, Acronyms, and Abbreviations
* **AI Copilot** – Context-aware assistant embedded within the LMS that provides explanations, drafting, localization, search, and coaching.
* **Quick Wins** – Action-oriented assignments or templates designed to drive immediate learner outcomes.
* **RAG** – Retrieval-Augmented Generation, used by the Copilot to cite course material.
* **MSME** – Micro, Small, and Medium Enterprises.
* **LMS Job Application** – Learner-submitted record capturing interest in a job opportunity via the LMS.

### 1.4 References
* `docs/BRD.md` — Business Requirements Document for Eliyana LMS.
* Frappe Learning documentation and DocType specifications.

### 1.5 Document Overview
Sections 2–4 describe functional requirements, Section 5 outlines non-functional expectations, and Sections 6–8 provide supporting constraints, data considerations, and traceability guidance.

## 2. Overall Description

### 2.1 Product Perspective
The platform reuses Frappe Learning as a base application. Eliyana-specific extensions include:
* AI Copilot side panel with localized support and assignment coaching.
* Jobs marketplace module (Job Settings, Job Opportunity, LMS Job Application) with site publishing and analytics hooks.
* Integrations pipeline for Eventbrite and Canva to automate learner enrollment.
* Localization assets, branding, and cohort-oriented Quick Win workflows.

### 2.2 Product Functions
1. Deliver structured courses (chapters, lessons, quizzes, assignments) with progress tracking and certificates.
2. Provide an AI Copilot panel accessible from lessons, assignments, and Quick Win templates.
3. Automate lead ingestion and enrollment via external integrations.
4. Maintain dashboards and reports for activation, Copilot usage, conversions, retention, and jobs marketplace performance.
5. Enable MSME-aligned jobs publishing, browsing, and application tracking.
6. Support instructor and operations workflows for content management, cohort coordination, and learner support.

### 2.3 User Classes and Characteristics
* **Learners:** Early-stage founders and MSME operators consuming mobile-first coursework, interacting with the Copilot, and applying to jobs.
* **Instructors/Program Managers:** Publish content, review assignments and Quick Wins, manage cohorts, and monitor analytics.
* **AI/Analytics Specialists:** Configure Copilot prompts, monitor token budgets, analyze ROI, and ensure safe operation.
* **Operations & Support:** Handle integrations, troubleshoot enrollment flows, and manage employer relationships.
* **Employers/MSME Partners:** Publish job opportunities, review applicants, and report hiring outcomes.
* **Administrators/DevOps:** Manage deployment, system configuration, security, and compliance.

### 2.4 Operating Environment
* Hosted initially on Frappe Cloud with migration path to self-hosted infrastructure (Docker benches on AWS/DigitalOcean).
* Supports modern desktop and mobile browsers with responsive layouts; optimized for low bandwidth connections typical in target African markets.

### 2.5 Design and Implementation Constraints
* Must comply with AGPL licensing when modifying Frappe source.
* AI provider integrations must allow cost tracking and regional data residency alignment.
* Localization must support English, Swahili, and Shona with fallback mechanisms.
* Storage of learner-generated content and resumes must respect privacy policies and retention limits (≤90 days for Copilot logs).

### 2.6 Assumptions and Dependencies
* Eventbrite and Canva integrations remain available with webhook access and API keys.
* Token usage data is accessible from the AI provider for budgeting.
* Employers agree to surface hires or interview outcomes for analytics.
* Frappe framework upgrades do not break customized DocTypes; regression testing will accompany major version changes.

## 3. System Features

### 3.1 Course and Cohort Management
* Support creation of courses with chapters, lessons, quizzes, assignments, and Quick Win templates.
* Provide cohort enrollment flows with status tracking (invited, active, completed).
* Offer learner dashboards summarizing progress, Quick Win submissions, certificates, and job applications.
* Enable instructors to configure course prerequisites, availability windows, and certification criteria.

### 3.2 AI Copilot Experience
* **Invocation:** Copilot toggle visible within lessons, assignments, and Quick Win templates; keyboard-accessible shortcut.
* **Modes:** Collapsible icon → expanded drawer (30–40% viewport width) → full-screen modal for deep dives.
* **Capabilities:** Explain Lesson, Draft (≤120 words), Localise (English ↔ Swahili ↔ Shona), Search My Course with citations, Assignment Coach for step guidance, follow-up questions.
* **Context Handling:** Maintain per-lesson conversation history; prevent cross-course leakage.
* **Feedback:** Prompt learners to rate helpfulness (1–5) post-interaction and capture qualitative comments.
* **Safety:** Enforce refusal patterns for disallowed content; redact PII from logs; highlight disclaimers on AI-generated suggestions.

### 3.3 Jobs Marketplace Module
* **Job Settings:** Configure branding, categories, and default filters; manage employer onboarding templates.
* **Job Opportunity:** Store job title, description, company info, location, employment type, required skills, compensation range, and status.
* **Publishing:** Render jobs at `/lms/job-openings` with search, filter, and responsive cards; expose RSS/JSON feed for syndication.
* **Applications:** Authenticated learners submit LMS Job Applications with resume uploads (PDF/DOCX ≤5 MB) and cover message; guest users can browse but must sign in to apply.
* **Workflow:** Employers/instructors receive notifications on new applications, can update status (new, reviewing, interview, offer, closed), and record hire confirmations.
* **Analytics:** Track applications per posting, conversion to interviews/offers, and correlation with course completion; data feeds into overall dashboards.

### 3.4 Integrations and Automation
* **Eventbrite → Canva → LMS Flow:** Webhooks trigger lead ingestion, deduplicate by email, create/update learner records, enroll in mapped courses/cohorts, and dispatch branded welcome emails.
* **Health Monitoring:** Admin interface surfaces last sync timestamp, failures, and retry controls.
* **Notifications:** Slack/email alerts for integration errors and monthly summaries of new leads.
* **Extensibility:** Provide configuration to add future lead sources without redeploying core code.

### 3.5 Analytics and Reporting
* Activation funnel dashboards (sign-up → lesson start → Chapter 1 completion).
* Copilot usage reports showing interactions, token consumption, helpfulness ratings, and refusal counts.
* Conversion tracking from free to paid offerings and workshop attendance.
* Jobs marketplace analytics highlighting applications per posting, time-to-hire, and learner outcomes.
* Exportable CSV reports for cohorts, AI costs, and job application pipelines.

### 3.6 Administration and Operations
* Theming controls for Eliyana branding across web and email surfaces.
* Budget controls for AI usage (per-user quotas, admin alerts at 80% monthly threshold).
* Role-based access management aligned with Frappe permissions (Learner, Instructor, Employer, Admin).
* Audit logs capturing key actions (course publish, job status change, data export).
* Documentation for deployment automation, secrets management, and incident response.

## 4. External Interface Requirements

### 4.1 User Interfaces
* Responsive layout optimized for mobile-first usage; leverage Frappe UI components with Eliyana branding.
* Copilot entry point accessible via icon/button with tooltip; states follow WCAG 2.1 AA contrast and focus indicators.
* Jobs marketplace listing cards include company logo, title, location, tags, and application CTA.
* Admin dashboards accessible via role-based navigation with filterable tables and export buttons.

### 4.2 APIs and Integrations
* REST/GraphQL endpoints for course metadata, learner progress, and job postings should include authentication checks and rate limits.
* Webhook endpoints accept JSON payloads from Eventbrite and Canva, returning 2xx on success and structured errors otherwise.
* AI provider integration uses HTTPS endpoints with retry logic (exponential backoff) and circuit breaking after configurable failures.

### 4.3 Data Interfaces
* Use Frappe DocTypes for structured storage; enforce schema validations, mandatory fields, and attachment size limits.
* Data exports (CSV/JSON) include metadata for traceability (generated timestamp, filters applied).

### 4.4 Security Interfaces
* OAuth or token-based authentication for external integrations; secrets stored in environment variables/bench config.
* Multi-factor authentication (MFA) option for admin accounts.

## 5. Non-functional Requirements

### 5.1 Performance
* Page load (LCP) ≤3 seconds on 3G Fast conditions for primary learner flows.
* Copilot first token latency <2 seconds target; 90th percentile response <8 seconds.
* Jobs listing search/filter responses <1.5 seconds for 95th percentile queries.

### 5.2 Reliability & Availability
* Target 99.5% uptime during pilot; 24/7 monitoring with alerting on critical failures.
* Provide automated backups (daily) and tested restore procedures.

### 5.3 Security & Privacy
* Encrypt data in transit (TLS 1.2+) and at rest (database encryption or encrypted volumes).
* Implement least privilege roles and audit trails for sensitive actions.
* Retain Copilot logs ≤90 days; purge resumes 12 months after job closure unless consent extends storage.
* Comply with applicable data protection regulations (e.g., NDPR, POPIA, GDPR for EU participants).

### 5.4 Localization & Accessibility
* Provide localized UI strings and content in English, Swahili, and Shona with runtime switching.
* Ensure WCAG 2.1 AA compliance, including screen-reader support, keyboard navigation, and captions/transcripts for multimedia.

### 5.5 Maintainability & Scalability
* Document customizations in repository docs; follow modular app structure for Frappe custom apps.
* Implement automated testing (unit, integration, end-to-end) for critical flows including Copilot and jobs module.
* Support horizontal scaling via additional Frappe workers and caching strategies as user load grows.

### 5.6 Cost Management
* Track AI token spend per user and per course; expose admin dashboards showing budget consumption.
* Provide configurable throttling when costs exceed thresholds.

## 6. Data Requirements
* Define DocType fields for Job Opportunity and LMS Job Application consistent with BRD scope.
* Maintain data lineage for Quick Win submissions, Copilot interactions, and job applications to support analytics correlations.
* Store learner consent for AI usage and job referrals; expose data deletion workflows for compliance.
* Implement anonymization for analytics exports when data is used externally.

## 7. AI Copilot Operational Requirements
* Support prompt templates per lesson or course with version control.
* Log key metrics: interaction timestamps, token usage, model version, refusal reasons, and learner feedback scores.
* Provide admin tooling to simulate prompts with test data before publishing to production.
* Enable fallback to alternative model or provider in case of degradation, with documentation for switchover.
* Enforce guardrails that block disallowed topics and escalate flagged content to instructors when necessary.

## 8. Integration Requirements
* Eventbrite webhook payloads must include event ID, attendee details, and ticket type to map to cohorts.
* Canva form submissions deliver company metadata to enrich learner profiles for B2B cohorts.
* Outbound notifications (email/SMS) use provider APIs with retry policies and localization support.
* Provide integration test suites and sandbox configurations for QA environments.

## 9. Traceability Guidance
* Maintain a traceability matrix linking BRD Section 5 scope items and Section 6 detailed requirements to SRS features in Sections 3 and 4.
* Update matrix whenever new jobs marketplace capabilities, AI Copilot features, or integrations are introduced.
* Reference this SRS in design documents, user stories, and QA plans to ensure alignment.

## 10. Appendices
* **Appendix A – Revision History:** Capture version, date, author, and summary of changes.
* **Appendix B – Open Questions:** Track outstanding decisions (e.g., preferred AI provider variants, employer onboarding SLAs).
* **Appendix C – Compliance Checklist:** Map requirements to relevant regulations (AGPL, NDPR, POPIA, GDPR).
