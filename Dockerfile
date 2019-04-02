FROM microsoft/iis:10.0.14393.206
SHELL ["powershell"]

RUN Install-WindowsFeature NET-Framework-45-ASPNET ; \
    Install-WindowsFeature Web-Asp-Net45

RUN mkdir Jabbr
WORKDIR Jabbr

RUN Remove-WebSite -Name 'Default Web Site'
RUN New-Website -Name 'jabbr' -Port 80 \
    -PhysicalPath 'C:\Jabbr' -ApplicationPool '.NET v4.5'

COPY JabbR/bin/Release/Publish .

EXPOSE 80

ENTRYPOINT powershell.exe -File c:\Jabbr\Startup.ps1
