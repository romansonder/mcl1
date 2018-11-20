########################################################################
# How to use git
########################################################################
First time you run git:
$ git clone https://github.com/romansonder/mcl1.git

$ git pull			# download the newest files from git

$ git add *			# select the files you want to upload
$ git commit			# write in your changes
$ git push			# upload your files to git


########################################################################
# Run the Makefiles on Windows:
########################################################################

#-----------------------------------------------------------------------
# Installation of cygwin
#-----------------------------------------------------------------------
Install cygwin from this site:
https://cygwin.com/install.html

Select a Download Site (mirror), if possible one in your country.

Select the following packages to be installed (allways newest version):

make: the Gnu version
git: Distributed version
texlive: TEX Live binaries
texlive-collection-latex
texlive-collection-latexextra
texlive-collection-langerman
texlive-collection-bibtexextra
texlive-collection-context
texlive-collection-fontsrecommended
texlive-collection-formatsextra
texlive-collection-pictures
texlive-collection-plaingeneric
texlive-collection-mathscience


#-----------------------------------------------------------------------
# Change to the Directory and run the Makefile
#-----------------------------------------------------------------------
open the cygwin terminal

clone the git repository
$ git clone http://..

change to the directory with the Makefile (use tab to autofill)
$ cd pro4e/documentation/02_technical_report/

run makefile
$ make

clean the directory from unused files
$ make clean

