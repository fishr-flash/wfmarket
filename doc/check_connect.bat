@echo off
color 1a
TITLE CHECK INTERNET CONNECTION
:check_connection
:: server I
ping -n 2 yandex.ru | find "TTL=" > nul
if %ERRORLEVEL% EQU 0 echo connect
if %ERRORLEVEL% EQU 1 (
	echo disconnect 
	C:\Windows\System32\rasdial.exe rk pbn pbn
)
:: end check
::exit
TIMEOUT /T 600
cls
goto check_connection

:connetcion
C:\Windows\System32\rasdial.exe rk pbn pbn