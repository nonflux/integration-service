# Collapsible PR Comment Implementation

## Completed

Implemented collapsible, in-place comment updates for agent comments in GitHub PRs, following the pattern from cicaddy-action:

### Changes Made

1. **git/github/github.go**:
   - Modified `GetExistingCommentID()` to use HTML comment markers instead of text search
   - Added `buildCommentMarker()` to generate unique markers per component/scenario
   - Added `stripFooter()` to remove footers before collapsing old content
   - Added `buildUpdatedCommentBody()` to prepend new content and collapse previous analyses into `<details>` sections
   - Added `BuildCommentWithMarker()` to wrap comments with markers and footers
   - Added `BuildUpdatedComment()` public method for building updated comments
   - Updated `ClientInterface` to include `BuildUpdatedComment` method
   - Implemented character limit handling (65,000 chars) with truncation

2. **status/reporter_github.go**:
   - Modified `updateStatusInComment()` to:
     - Wrap new comments with marker and footer using `BuildCommentWithMarker()`
     - Build updated comments with collapsible history when updating existing comments
     - Use marker-based comment identification

### How It Works

1. Each comment starts with a unique HTML marker: `<!-- integration-service:component=X:scenario=Y -->`
2. When updating, the old content is wrapped in a collapsible `<details>` section
3. New content appears at the top, followed by "Previous analyses" in a collapsed section
4. If history exists, it's preserved and expanded
5. Comments are truncated if they exceed GitHub's 65K character limit

## Tests Updated ✅

1. **git/github/github_test.go**:
   - Updated `MockIssuesService.ListComments` to return comment body with new marker format
   - Test validates marker-based comment identification works correctly
   - All 14 tests passing

2. **status/reporter_github_test.go**:
   - Updated test "creates a commit status for snapshot with correct textual data" to expect new comment format
   - Changed from exact string match to substring matching for marker, content, and footer
   - Added `BuildUpdatedComment()` method to `MockGitHubClient`
   - All 144 tests passing

## Migration Consideration

- **Breaking Change**: Existing comments without markers will not be found by the new logic
- When next update happens, a new comment will be created with markers
- Old comments will remain but won't be updated anymore
- This is acceptable as it's a clean transition to the new format

## Next Steps

1. **Integration Testing**:
   - Test with real PRs to verify collapsible comments work correctly
   - Verify character limit handling (65K chars)
   - Confirm history preservation across multiple updates
   - Test marker uniqueness per component/scenario

2. **Consider GitLab/Forgejo**:
   - Check if similar changes are needed for GitLab/Forgejo reporters
   - They have similar comment update logic that could benefit from collapsing

3. **Documentation**:
   - Consider adding a comment in code explaining the marker format
   - Update any relevant documentation about PR comment behavior
