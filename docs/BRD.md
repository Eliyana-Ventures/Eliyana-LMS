# Eliyana LMS Platform — Business Requirements Document (BRD)

## 1. Executive Summary
Eliyana Ventures is launching “Eliyana Academy,” an Africa-first learning platform that combines structured coursework for founders and MSMEs with an embedded AI Copilot that accelerates understanding and execution. The platform is derived from the open-source Frappe Learning codebase and will be piloted on Frappe Cloud before graduating to self-hosted infrastructure. This BRD aligns product, engineering, growth, and operations teams on business goals, success criteria, and scope for the initial 12-month rollout.

## 2. Vision & Strategic Alignment
* **Platform fit:** Primary platform is Leadership & Education (L&E); cross-impact to Entrepreneurship & Economy (E&E) by translating learning into measurable business outcomes.
* **North-star vision:** Deliver a lightweight, mobile-friendly environment where African founders learn and apply lessons in one place. The AI Copilot side panel (collapsible, expandable, full-screen) provides contextual explanations, localized drafts, targeted search, and assignment coaching while keeping a human-in-the-loop model.
* **Strategic differentiators:** Africa-first localization, actionable “Quick Win” focus, transparent and cost-controlled AI assistance, seamless transition from free learning to premium workshops/cohorts, and an embedded jobs marketplace connecting learners with MSME-friendly roles.

## 3. Business Objectives (12-Month Horizon)
1. **Activation:** ≥60% of new learners complete Chapter 1 within 7 days; ≥60% trigger the Copilot within 48 hours.
2. **Impact:** ≥40% of learners submit at least one “Quick Win” deliverable within 14 days.
3. **Conversion:** ≥15% of free learners convert to a paid workshop or cohort.
4. **Efficiency:** Maintain AI Copilot cost at ≤$0.08 per interaction on average.
5. **Retention:** Achieve ≥35% monthly returning learners.

## 4. Stakeholders & Responsibilities
| Stakeholder | Role | Responsibilities |
|-------------|------|------------------|
| Product Management | Business owner | Backlog prioritization, scope alignment with vision and KPIs |
| Engineering (Backend, Frontend, DevOps) | Delivery teams | Implement LMS features, AI Copilot, integrations, and deployment automation |
| Data & Analytics | Insights | Define instrumentation, build dashboards, monitor KPIs |
| AI/ML Team or Vendor | Copilot provider | Model selection, prompt engineering, guardrails, cost management |
| Instructional Design & Content | SMEs | Create courses, Quick Win templates, localized assets |
| Customer Success & Ops | Pilot execution | Cohort onboarding, support, feedback loops |
| Compliance & Security | Governance | Ensure privacy, data retention, and ethical AI practices |

## 5. Scope Overview (V1)
### 5.1 In Scope
* **LMS Core:** Courses, chapters, lessons, quizzes, assignments, cohorts/batches, certificates, progress tracking, notifications, billing hooks (aligned with existing Frappe features).
* **Branding & Theming:** Eliyana brand assets, localized content, templates for promos and Quick Wins.
* **AI Copilot:** Context-aware side panel with history, streaming responses, localized drafting (English, Swahili, Shona), lesson explanations, course search with citations, assignment coaching, and refusal patterns for unsafe requests.
* **Integrations:** Eventbrite → Canva Form → LMS webhook flow for lead ingestion, auto-enrollment, and welcome email automation.
* **Jobs Module:** Configurable job board (Job Settings, Job Opportunity, LMS Job Application DocTypes), website publishing, applicant tracking, and instructor-facing workflows to promote MSME hiring opportunities alongside courses.
* **Analytics & Telemetry:** Activation funnel, Copilot engagement (usage, token cost, helpfulness rating), conversion metrics, retention tracking, and job board KPIs (applications per posting, hires reported).
* **Deployment:** Managed pilot on Frappe Cloud using FC APIs/webhooks; documentation for migration to AWS/DigitalOcean benches post-pilot.

### 5.2 Out of Scope (V1)
* Native mobile apps.
* Automatic grading or generative evaluation of assignments.
* Marketplace functionality beyond curated Eliyana programs.
* Complex payment gateways beyond current Frappe integrations.
* AI features that operate without human oversight or violate privacy guardrails.

## 6. Detailed Business Requirements
### 6.1 Learner Experience
1. Provide a guided onboarding flow emphasizing Quick Win outcomes and demonstrating Copilot capabilities.
2. Ensure lessons, assignments, and Quick Win templates are optimized for low-bandwidth and mobile consumption.
3. Offer clear progress indicators across chapters, cohorts, and Quick Wins.
4. Allow learners to trigger the Copilot from any lesson or assignment, preserving per-lesson history.
5. Capture learner feedback on Copilot helpfulness immediately after interactions (1–5 scale).
6. Surface curated job opportunities relevant to course tracks, allowing learners to search, filter, and apply without leaving the learning environment.

### 6.2 Instructor & Operations Experience
1. Deliver authoring tools to publish courses rapidly, leveraging existing Frappe DocTypes and templates.
2. Provide dashboards for cohort enrollment, Quick Win submissions, and Copilot usage per learner.
3. Enable instructors to review Copilot summaries of learner interactions to inform manual feedback.
4. Automate notifications for pending approvals, submissions, and budget alerts for AI usage.
5. Allow instructors and Eliyana ops teams to publish, edit, and monitor job opportunities (including applicant counts and status) directly from the LMS admin tools.

### 6.3 AI Copilot Requirements
1. **Panel Behavior:** Collapsible button → expanded drawer (30–40% width) → full-screen mode; keyboard and screen-reader accessible.
2. **Capabilities:** Explain Lesson, Draft ≤120 words, Localise (English ↔ Swahili ↔ Shona), Search My Course (RAG with citations to lesson content), Assignment Coach suggestions.
3. **Human-in-the-loop:** Encourage manual review via UI prompts; surface disclaimers and refusal reasons when queries fall outside allowed scope.
4. **Safety & Privacy:** Scope retrieval to enrolled courses, redact PII in logs, enforce 90-day retention, and implement refusal patterns for unsafe or irrelevant requests.
5. **Cost Controls:** Track tokens and interaction counts, support per-user quotas, and trigger admin alerts at 80% of monthly budget.
6. **Performance:** Fast first token (<2s target on pilot bandwidth) and overall latency (<8s for 90th percentile interactions).

### 6.4 Integrations & Automation
1. Ingest Eventbrite registrations and Canva form responses via webhook, deduplicate leads, create/update users, auto-enroll them in relevant courses/cohorts, and send branded welcome emails.
2. Provide admin interfaces to monitor integration health, with retry and error notification mechanisms.
3. Prepare for zero-rated/reverse-billed data partnerships by documenting network requirements and capturing partner metadata per cohort.

### 6.5 Jobs & Career Services
1. Maintain a branded jobs landing page (`/lms/job-openings`) that lists active Job Opportunity records with company branding, location, type, and applicant counts.
2. Enable logged-in learners to submit LMS Job Applications with resume uploads, and track application history directly from their account.
3. Provide optional guest browsing while gating application actions behind authentication to support lead capture.
4. Allow job owners to update postings, disable filled roles, and review applicant volume using built-in Frappe reports.
5. Extend analytics to correlate job applications with course completions and Quick Win achievements for impact reporting.

### 6.6 Analytics & Reporting
1. Implement dashboards that visualize activation funnel (sign-up → lesson start → Chapter 1 completion), Copilot usage frequency, Quick Win submissions, conversion to paid programs, and retention.
2. Attribute Copilot interactions to downstream outcomes (Quick Win completion, conversion) for ROI analysis.
3. Offer exportable reports for cohort performance, AI cost summaries, and job application outcomes (application counts, hire confirmations).

### 6.7 Deployment & Operations
1. Pilot deployment on Frappe Cloud using automated provisioning scripts, FC webhooks for site lifecycle, and configuration templates for branding, payments, and telemetry.
2. Document migration path to self-hosted infrastructure (AWS/DigitalOcean) including Docker bench setup, secrets management, monitoring, and incident response expectations.
3. Establish SLOs for uptime, response time, and support during the pilot.
4. Maintain compliance with AGPL obligations and ensure third-party license compatibility.

## 7. Success Metrics & Acceptance Criteria
| Area | Metric | Acceptance Criteria |
|------|--------|---------------------|
| Copilot UX | Panel behavior | Overlay works without layout breaks; keyboard accessible paths verified |
| Copilot Accuracy | RAG coverage | ≥70% of test queries return cited lesson chunks |
| Copilot Satisfaction | Helpfulness score | ≥80% of pilot users rate ≥4/5 |
| Cost | Cost per interaction | ≤$0.08 average during pilot week |
| Learning Outcomes | Quick Win submissions | ≥40% within 14 days |
| Activation | Chapter 1 completion | ≥60% in 7 days |
| Conversion | Paid upgrades | ≥15% free → paid |
| Retention | Returning learners | ≥35% monthly |
| Jobs Marketplace | Applications per posting | Average ≥5 qualified applications per open job during pilot |
| Jobs Marketplace | Hire reporting | ≥20% of postings report a hire or interview progressed through the LMS channel |
| Integrations | Enrollment automation | Eventbrite→Canva→LMS flow succeeds; welcome email delivered |

## 8. Risks & Mitigations
* **AI Cost Overruns:** Implement usage caps, dynamic model selection, and alerting at 80% budget.
* **Data Privacy Concerns:** Restrict retrieval scope, anonymize analytics, and align with regional regulations.
* **Connectivity Constraints:** Optimize content for low bandwidth, cache Copilot prompts/responses per session, and provide offline-friendly materials where feasible.
* **Job Pipeline Adoption:** Position the jobs module during onboarding and provide templates for employers to encourage consistent postings.
* **Localization Gaps:** Invest in QA for Swahili/Shona translations and allow manual overrides.
* **Vendor Dependency:** Maintain documentation for alternative AI providers and exportable data schemas.
* **Change Management:** Provide instructor training and support materials before pilot launch.

## 9. Implementation Roadmap (Indicative)
1. **Foundations (Month 0–1):** Pilot scope confirmation, hosting setup on Frappe Cloud, branding and content migration.
2. **AI Copilot MVP (Month 1–2):** Panel UX, Explain/Draft/Localise tools, usage analytics, budget controls.
3. **Integration Automation (Month 2–3):** Eventbrite/Canva pipeline, welcome journeys, Quick Win templates.
4. **Analytics & Reporting (Month 3–4):** Activation funnel dashboards, Copilot ROI reporting.
5. **Pilot Launch & Iteration (Month 4–6):** Monitor KPIs, collect user feedback, adjust Copilot prompts.
6. **Scale & Self-Hosting Prep (Month 6–12):** Optimize costs, expand localization, ready AWS/DigitalOcean deployment option.

## 10. Appendices
* **Reference SRS:** See `docs/SRS.md` (to be maintained) for technical specifications backing these requirements.
* **Glossary:** Quick Win, Copilot interaction, RAG (Retrieval-Augmented Generation), Zero-rated delivery.
* **Revision Plan:** Update BRD quarterly or when major feature pivots occur; maintain traceability to SRS, design documents, and implementation tickets.
