#how to run this ::
# first make it executabale
#          chmod +x git-sync.sh
#          ./git-sync.sh "your commit message here"
#*************************script********************
# 1. Check current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Syncing changes to branch: $BRANCH"

# 2. Show git status
git status

# 3. Add all new/changed files
git add -A

# 4. Commit with message (use argument or default message)
if [ -z "$1" ]; then
    COMMIT_MSG="Update on $(date '+%Y-%m-%d %H:%M:%S')"
else
    COMMIT_MSG="$1"
fi

git commit -m "$COMMIT_MSG"

# 5. Pull latest changes to avoid conflicts
git pull origin "$BRANCH" --rebase

# 6. Push to GitHub
git push origin "$BRANCH"

echo "✅ Changes pushed successfully!"
