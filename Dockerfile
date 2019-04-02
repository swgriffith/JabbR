FROM microsoft/dotnet-framework:4.7.2-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY JabbR/*.csproj ./JabbR/
COPY JabbR/*.config ./JabbR/
COPY .nuget .nuget
RUN nuget restore

# copy everything else and build app
COPY JabbR ./JabbR
WORKDIR /app/JabbR
RUN msbuild /p:Configuration=Release


# copy build artifacts into runtime image
#FROM microsoft/aspnet:4.7.2 AS runtime
#WORKDIR /inetpub/wwwroot
#COPY --from=build /app/Jabbr/. ./

FROM microsoft/iis:10.0.14393.206 AS runtime
SHELL ["powershell"]

RUN Install-WindowsFeature NET-Framework-45-ASPNET ; \
    Install-WindowsFeature Web-Asp-Net45

RUN mkdir Jabbr
WORKDIR Jabbr

RUN Remove-WebSite -Name 'Default Web Site'
RUN New-Website -Name 'jabbr' -Port 80 \
    -PhysicalPath 'C:\Jabbr' -ApplicationPool '.NET v4.5'

COPY --from=build /app/Jabbr/. ./

EXPOSE 80

ENTRYPOINT powershell.exe -File c:\Jabbr\Startup.ps1
