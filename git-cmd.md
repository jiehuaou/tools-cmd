
# config proxy if need like

 git config --global http.proxy 127.0.0.1:7890



# create a new repository on the command line

echo "# demo-new" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/jiehuaou/demo-1to-many.git
git push -u origin main

# r push an existing repository from the command line

git remote add origin https://github.com/jiehuaou/demo-1to-many.git
git branch -M main
git push -u origin main


# How can I merge two branches without losing any files?

	git checkout a (you will switch to branch a)
	
	git merge b (this will merge all changes from branch b into branch a)
	
	git commit -a (this will commit your changes)
	
	
## pull origin branch master and merge into current branch ( current branch is created from master )
```
   A---B---C (master)
    \
     \
      D---E (branch-123)
```	
	git pull origin master

```
   A---B---C (master)
    \
     \
      B---C---D---E (branch-123)
```	
	
	
## replace local branch with remote develop branch entirely  
	
	git reset --hard origin/CAED-788
	
# status, verify status

	git status
	
# configure git for the first time

	git config --global user.name "Hello OU"
	git config --global user.email "hello@comp.com"
	
	
# create branch

	git checkout -b feature/fix-123
	
# undo latest pushed commit 

	** revert changes **
	
	git revert <commit 1> <commit 2>
	git push
	
	** OR delete all before <last_good_commit>, clean history **
	
	git reset --hard <last_good_commit>
	git push --force 
	
	** OR delete for example the last 3 commits, clean history **
	
	git reset --hard HEAD~3
	git push --force             ( git push -f origin bugfix/bug123 )
	
# undo add file before commit

	git reset <file>
	
# amend the most recent commit

	git commit --amend -m "new message"
	
	git push -f
	
# show diff of commit

	git show <commit_hash_id>
	
	
# rebase

```
   A---B---C (master)
    \
     \
      D---E (branch-123)
```	

	Step 1: git checkout branch-123
	
	Step 2: git rebase master
	
	Step 3: Resolve conflicts
	
	Step 4: git add myfile.txt
	
	Step 5: git rebase --continue

	Step 6: git push  --force 
	
```
   A---B---C (master)
           \
            \
             D---E (branch-123)
```	



# Remove a git commit which has not been pushed

    1 - Undo commit and keep all files staged: git reset --soft HEAD~

    2 - Undo commit and unstage all files: git reset HEAD~

    3 - Undo the commit and completely remove all changes: git reset --hard HEAD~


# cherry-pick:  to merge commit e27af03 from branch X to master.

pick before
```
a - b - c - d       Main
         \
           e - e27af03 - g    Feature

```

command
```		   
git checkout master

git cherry-pick e27af03       # directly be committed 

git push
```

after
```
a - b - c - d - e27af03      Main
         \
           e - e27af03 - g   Feature
```    
     

# How to combine 7 pushed commits into one via cmd

git reset --soft HEAD~7
git add --all
git commit
git push --force

# How to squash 2 commits into one via IntellJ
 
* select the 2 commit	 
* choose squash and edit message 
* git push --force


# create branch123 from master

git checkout -b branch123 master

