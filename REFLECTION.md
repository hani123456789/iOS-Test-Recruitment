# REFLECTION.md

## Project Overview

This iOS application displays classified listings from a local API server. It provides a listing feed with category filtering, pagination, loading/error/empty states, and a detail view for each listing.

The implementation focuses on keeping the architecture lightweight and testable while providing a clear and accessible user experience.

---

## AI Usage

### Tools Used

I used **ChatGPT** throughout the project as a development assistant for:

1. **Boilerplate and model generation**  
   Assistance with DTOs, domain model structures, repository protocols, and initial project scaffolding.

2. **SwiftUI view components**  
   Assistance with the initial implementation and refinement of `ListingsView`, `ListingCardView`, `ListingDetailView`, loading, error, and empty states.

3. **Accessibility**  
   Suggestions for meaningful VoiceOver labels, accessibility traits, and handling decorative images.

4. **Concurrency review**  
   Reviewed `async/await`, structured concurrency, and parallel API requests, while making the final decisions about how concurrency is handled in the application.
   
All suggestions were reviewed and adapted before integration. I did not rely on AI to generate full features, but rather to challenge and refine my decisions.

---

## AI Suggestions I Rejected or Corrected

### 1. State Management Pattern

**AI Suggested:** Using separate `@Published` properties such as `isLoading`, `error`, and `listings`.

**I Corrected:** I implemented a single `State` enum with associated values:

- `.idle`
- `.loading`
- `.loaded`
- `.empty`
- `.error(APIError)`

This makes the possible UI states explicit and mutually exclusive, avoiding inconsistent combinations such as simultaneously having a loading state and an error state.

---

### 2. Image URL Construction

**AI Suggested:** Constructing image URLs directly in the View layer using string interpolation.

**I Corrected:** I moved URL construction to the DTO → Domain mapping layer.

The API returns server-relative image paths, while the domain model exposes `URL?` values ready for presentation. This keeps networking concerns outside the View layer and allows `AsyncImage` to consume the resulting URL directly.

Missing image paths are represented as `nil` and handled gracefully by the UI with a placeholder.

---

### 3. Category Filtering

**AI Suggested:** Performing category filtering through additional API requests using a category query parameter.

**I Decided:** I implemented client-side filtering because the API does not expose a category filter parameter. This was verified against the provided `swagger.yaml`.

The filtering is therefore applied to the listings already loaded by the application while preserving the order returned by the API.

---

## Architectural Decisions I Owned

I implemented a lightweight architecture based on the **MVVM pattern**, with a clear separation between Views, ViewModels, repositories, DTOs, and domain models.

### MVVM

SwiftUI Views are responsible for presentation and user interaction, while ViewModels handle UI state and coordinate application logic.

This keeps the Views relatively declarative and prevents networking and business logic from being embedded directly in the UI.

### Repository Pattern

I separated data access into repository implementations such as:

- `ListingRepository`
- `CategoriesRepository`

with protocol abstractions.

This provides:

- separation between data access and presentation logic
- easier ViewModel testing
- the ability to change or extend data sources later
- dependency inversion

### Dependency Injection

Dependencies are injected into the ViewModel and repositories instead of relying on global singletons.

This improves testability and makes dependencies explicit.

### DTO → Domain Model Mapping

I separated network DTOs from application domain models:

- `ListingDTO` / `CategoryDTO` are responsible for API decoding
- `Listing` / `Category` represent application-level data

Mapping is performed outside the View layer.

This also allows API-specific concerns such as server-relative image URLs to be resolved before the data reaches the UI.

### Concurrency

I used Swift structured concurrency with `async/await`.

Where independent API requests can run in parallel, structured concurrency such as `async let` is used to avoid unnecessary sequential waiting.

Pagination requests are also protected against concurrent loading through ViewModel state, preventing multiple next-page requests from being triggered simultaneously.

### UI State Management

The ViewModel centralizes the screen state using a `State` enum.

This allows the UI to explicitly handle:

- initial/loading state
- loaded state
- empty state
- error state
- idle state

The same state model is used to provide recoverable error handling and intentional empty states.

---

## Pagination

I implemented incremental pagination using the paginated listings endpoint.

The API provides pagination metadata including:

- `page`
- `limit`
- `has_more`

The next page is requested when the last displayed listing becomes visible.

The ViewModel uses an `isLoadingNextPage` flag to prevent multiple pagination requests from being triggered at the same time. Pagination stops when the API reports that there are no more pages.

New listings are appended to the existing collection, preserving the order returned by the API.

---

## Product and UX Decisions

I prioritized the core listing experience rather than adding unnecessary scope.

The listing screen provides:

- listing image
- category
- title
- price
- urgent indicator
- category filtering
- loading feedback
- recoverable error state
- intentional empty state

The detail screen provides a larger image and a clear information hierarchy containing:

- title
- price
- urgent indicator
- category
- publication date
- description

I also introduced a lightweight design system to centralize:

- colors
- typography
- spacing
- dimensions
- corner radii
- icons
- reusable formatting

This avoids scattering arbitrary visual constants throughout the SwiftUI views and makes future visual changes easier.

---

## Accessibility

Accessibility was considered as part of the UI implementation.

Interactive elements such as category filters and retry actions have meaningful accessibility labels and selected states where appropriate.

Listing images are given descriptive accessibility labels, while decorative placeholder icons are hidden from accessibility.

The UI uses SwiftUI's Dynamic Type-compatible system fonts rather than fixed text rendering sizes, allowing text to respond to the user's accessibility settings.

---

## Testing

I focused on a small set of meaningful automated tests rather than maximizing code coverage.

The tests are designed to be deterministic and do not require the local API server to be running.

The goal was to test important application behaviour rather than implementation details or achieve exhaustive coverage.

---

## Ambiguity in the Prompt/API and How I Handled It

### 1. Image URL Format

**Ambiguity:** The API specification states that image URLs are server-relative paths and that the server base URL should be prepended, but it does not require a specific URL construction approach.

**My Decision:** Image URLs are resolved during DTO → Domain mapping using the configured server base URL.

This keeps URL construction outside the View layer and ensures the domain model exposes ready-to-use `URL?` values.

Missing image paths and failed image loads are handled gracefully with placeholders.

---

### 2. Detail View Completeness

**Ambiguity:** The requirement states that the detail view should feel "complete and readable", which is subjective.

**My Decision:** I prioritized the information directly returned by the API and presented it using a clear visual hierarchy:

- full-width listing image
- title
- price
- urgent indicator
- category
- publication date
- description

This provides a concise detail experience without introducing information that is not available from the API.

---

## Scope and Tradeoffs

I prioritized the required listing and detail experiences, along with pagination, rather than expanding the scope with multiple optional features.

The API also exposes a search endpoint, but I did not implement search because it was optional. Given the time and scope of the exercise, I preferred to keep the implemented functionality focused and polished rather than introduce additional partially implemented features.

The same principle was applied to the UI architecture: I chose a lightweight MVVM structure instead of introducing additional architectural patterns such as a Coordinator or a more complex navigation layer that was not required by the application.

The goal was to keep the implementation simple enough for the size of the application while still providing clear separation of concerns, testability, accessibility, and room for future evolution.
