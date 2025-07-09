@echo off
setlocal
:: 获取脚本所在目录（build 目录）
set "BUILD_DIR=%~dp0"
set "BUILD_DIR=%BUILD_DIR:~0,-1%"
:: 计算项目根目录（build 的上级目录）
for %%i in ("%BUILD_DIR%\..") do set "PROJECT_ROOT=%%~fi"
:: 定义输出目录
set "OUTPUT_DIR=%PROJECT_ROOT%\build"
:: 新增：判断输出目录是否存在，存在则删除
if exist "%OUTPUT_DIR%\migrator" (
    echo "Output directory exists, deleting..."
    rd /s /q "%OUTPUT_DIR%\migrator"
    if errorlevel 1 (
        echo "Error: Failed to delete existing output directory!"
        goto :END
    )
)
:: 定义 input 目录（包含主 JAR 的目录）
set "INPUT_DIR=%PROJECT_ROOT%\target"
:: 验证主 JAR 是否存在
if not exist "%INPUT_DIR%\migrator-1.0.jar" (
    echo "Error: Master JAR file does not exist! Please check the path:%INPUT_DIR%\migrator-1.0.jar"
    goto :END
)
:: 执行打包（使用相对于 input 目录的路径指定主 JAR）
jpackage ^
    --type app-image ^
    --name migrator ^
    --input "%INPUT_DIR%" ^
    --main-jar migrator-1.0.jar ^
    --main-class com.migrator.Migrator ^
    --icon "%PROJECT_ROOT%\build\migrator.ico" ^
    --java-options "-Dfile.encoding=UTF-8" ^
    --dest "%OUTPUT_DIR%" ^
    --win-console
if errorlevel 1 (
    echo "failed!"
    goto :END
)
:: 复制 app 目录内容到输出目录
echo "Duplicating app catalogs..."
xcopy /E /Y /I "%PROJECT_ROOT%\app" "%OUTPUT_DIR%\migrator\app"
echo "Packed, done! Output directory:%OUTPUT_DIR%"
:END
endlocal