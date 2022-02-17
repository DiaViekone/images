@echo off
git pull
git add -A
git commit -m update
git push -f origin master
exit
