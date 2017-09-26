## JabbR
JabbR is a chat application built with ASP.NET using SignalR. This repo is forked from the original repo here: https://github.com/JabbR/JabbR

![jabbr.net](https://raw.githubusercontent.com/JabbR/JabbR/ea5a15e6bc8c0d5dba2a69053c340e8c4755459e/Content/images/screenshot.png)

To get started follow these steps:

1. Clone this repo

2. Open the `JabbR.sln` file in Visual Studio 2015 or 2017

3. Restore the nuget packages.

4. Build the solution.

5. Run the solution locally to validate that it works

6. Create a blank Azure SQL Database via the Azure portal

7. Right the click the JabbR project in Visual Studio and choose publish. Publish the app to an Azure App Service.
![Publish to Azure](/images/jabbr-publish.gif)

8. Once the app has been published, navigate to the Azure portal and find the app.

9. Under the Application Settings -> Connection Strings, create a connection string called Jabbr and value is the connection string for the database you created in step 6.
![Add database connection string](/images/application-setting.gif)

10. Browse to the application and it should begin working.


