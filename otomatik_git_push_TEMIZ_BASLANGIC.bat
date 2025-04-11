
@echo off
SETLOCAL

:: -----------------------------
:: AYARLAR – BURAYI DOLDUR
set "GITHUB_KULLANICI_ADI=Mildorsbeta"
set "GITHUB_TOKEN=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"
set "REPO_ADI=mildorsbeta"
:: -----------------------------

:: Var olan git geçmişini tamamen sil
IF EXIST ".git" (
    echo Eski Git geçmişi siliniyor...
    rmdir /s /q .git
)

:: .gitignore oluştur (büyük dosyaları dışla)
echo *.exe > .gitignore
echo *.zip >> .gitignore

:: Git kurulu mu kontrol et
where git >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Git bulunamadi. Yükleniyor...

    :: Geçici klasör oluştur
    set "TEMP_DIR=%TEMP%\gitsetup"
    mkdir "%TEMP_DIR%" >nul 2>&1
    cd /d "%TEMP_DIR%"

    :: Git kurulum dosyasını indir
    powershell -Command "Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe -OutFile git-installer.exe"

    :: Git'i sessizce kur
    start /wait git-installer.exe /VERYSILENT /NORESTART /NOCANCEL

    echo Git basariyla kuruldu.
    cd /d "%~dp0"
)

:: Git ayarları ve işlemleri
echo --- Git islemleri basliyor ---
git init
git config user.name "bariscan"
git config user.email "bariscanataoglu@gmail.com"

git add .
git commit -m "Temiz baslangic yuklemesi"

:: Repo URL'si oluştur
set "REPO_URL=https://%GITHUB_KULLANICI_ADI%:%GITHUB_TOKEN%@github.com/%GITHUB_KULLANICI_ADI%/%REPO_ADI%.git"

git remote add origin %REPO_URL%
git branch -M main
git push -u origin main

echo --- Temiz yükleme tamamlandi! ---
pause
ENDLOCAL
