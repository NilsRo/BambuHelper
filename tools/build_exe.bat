@echo off
REM ─────────────────────────────────────────────────────────────────────────
REM  Build a standalone Windows .exe of bambu_diag.py with PyInstaller
REM
REM  One-time setup:
REM    pip install pyinstaller paho-mqtt curl_cffi
REM
REM  Then double-click this file, or run it from a terminal in tools/.
REM  Output lands in:
REM    dist\BambuHelper-CompanionTool.exe
REM ─────────────────────────────────────────────────────────────────────────

setlocal
cd /d "%~dp0"

REM PyInstaller's wrapper exe is often installed to a per-user Scripts dir
REM that isn't on PATH (especially with "pip install --user"). Invoke it as
REM a Python module instead to sidestep PATH entirely. Try "python" first,
REM then the "py" launcher.
set "PYI="
python -m PyInstaller --version >nul 2>&1 && set "PYI=python -m PyInstaller"
if not defined PYI py -m PyInstaller --version >nul 2>&1 && set "PYI=py -m PyInstaller"
if not defined PYI (
  echo ERROR: PyInstaller is not importable from "python" or "py".
  echo Install it with:  python -m pip install pyinstaller
  pause
  exit /b 1
)
echo Using: %PYI%

REM Clean previous build artifacts so we don't ship stale bundles
if exist build  rmdir /s /q build
if exist dist   rmdir /s /q dist
if exist BambuHelper-CompanionTool.spec del /q BambuHelper-CompanionTool.spec

%PYI% ^
  --onefile ^
  --console ^
  --name BambuHelper-CompanionTool ^
  --collect-all curl_cffi ^
  --collect-all paho ^
  --hidden-import certifi ^
  bambu_diag.py

if errorlevel 1 (
  echo.
  echo BUILD FAILED.
  pause
  exit /b 1
)

echo.
echo ─────────────────────────────────────────────────────────────
echo  BUILD OK
echo  Output: %CD%\dist\BambuHelper-CompanionTool.exe
echo ─────────────────────────────────────────────────────────────
echo.
echo Test it by double-clicking the .exe in dist\ .
pause
