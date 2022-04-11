# My github memo
# https://stackoverflow.com/questions/7028442/how-can-i-upload-committed-changes-to-my-github-repository
# How to push commmit and edit branches remotely

1. First clone your repo locally
  git clone https://github.com/natashamartin/INTREPID.git
2. next do your edits, add files, etc locally within this directory 
3. next, add
  git add <filename> or git add * to add everything
  git commit -m "uploaded by Antoine to try"
  git push

4. to upload onto a *new* branch
  4a. create a branch
    git branch mynewbranch
  OR
    git checkout -b mynewbranch
    
  4b. push into it
    git push -u origin mynewbranch

  
  
  ### to go deeper, one can set up a new main branch
  # https://stevenmortimer.com/5-steps-to-change-github-default-branch-from-master-to-main/
  
  # Step 1 
# create main branch locally, taking the history from master
git branch -m master main

# Step 2 
# push the new local main branch to the remote repo (GitHub) 
git push -u origin main

# Step 3
# switch the current HEAD to the main branch
git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main

# Step 4
# change the default branch on GitHub to main
# https://docs.github.com/en/github/administering-a-repository/setting-the-default-branch

# Step 5
# delete the master branch on the remote
git push origin --delete master
