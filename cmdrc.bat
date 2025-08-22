:: Open your registry and go to the following key:
:: HKEY_CURRENT_USER\Software\Microsoft\Command Processor OR
:: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor
:: and add a string value named AutoRun and valued with the
:: absolute path of this file. eg: %HOME%\cmdrc.bat.
::
:: You can also add shortcut target to this file. [This is preferred]
:: eg: %windir%\system32\cmd.exe /k %HOME%\cmdrc.bat

@echo off

set prompt=$P$_$+$G$S
clink.exe inject
set TERM=xterm-256color
cls

doskey ..=cd ..
doskey ...=cd ..\..
doskey :q=exit
doskey v=vim $*
doskey np=notepad $*
doskey ll=ls -lah $*
doskey gs=git status $*
doskey ga=git add .
doskey gc=git clone --depth=1 $*
doskey ggc=git commit -m "$*"
doskey pyserve=python -m http.server $*
doskey hss=hugo serve --noHTTPCache --bind 0.0.0.0 $*
doskey liveserve=browser-sync start --server -f -w $*
doskey cloc=tokei $*

doskey php8=C:\dev\php-8.2.3\php $*
doskey php7=C:\dev\php-7.4.33\php $*
doskey composer=php C:\util\composer.phar $*

doskey java=C:\dev\jdk\bin\java $*

doskey aastyle=C:\util\astyle --style=kr --indent=tab --convert-tabs --break-blocks --pad-oper --pad-header --unpad-paren --align-pointer=name --attach-return-type --indent-preproc-block --max-code-length=80 --break-after-logical --suffix=none $*
