# JabbR
This repo is forked from the original repo here: https://github.com/JabbR/JabbR and is designed as a starting point for a hands-on-lab with Azure.

JabbR is a chat application built with ASP.NET using SignalR.

![jabbr.net](https://raw.githubusercontent.com/JabbR/JabbR/ea5a15e6bc8c0d5dba2a69053c340e8c4755459e/Content/images/screenshot.png)

## Hands on Lab

### Part 1: Deploy the Application

To get started follow these steps:

1. Clone (or download) this repo

2. Open the `JabbR.sln` file in Visual Studio 2015 or 2017 (ignore the warning about SQL Express if you don't have it).

3. Restore the nuget packages (right click the solution and choose _restore nuget packages_)
![Restore nuget packages](/images/nuget-restore.png)

4. Build the solution and validate it succeeds.

5. Create a blank Azure SQL Database via the Azure portal. See [here](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-get-started-portal) for steps.

7. Right the click the JabbR **project** in Visual Studio and choose publish. Publish the app to an Azure App Service.
![Publish to Azure](/images/jabbr-publish.gif)

8. Once the app has been published, navigate to the Azure portal and find the app.

9. Under the Application Settings -> Connection Strings, create a connection string called **Jabbr** and set its value to the connection string for the database you created in step 5.
![Add database connection string](/images/application-setting.gif)

10. Browse to the application and it should begin working.

-------------
### Part 2: Deployment slots

-------------

### Part 3: Adding in some intelligence

In this section we are going to make a modification to the application to make it smarter. We will use Azure Cognitive Services to automatically caption images people upload.

1. Create an Azure Cognitive Service in your Azure Subscription, choosing the Computer Vision API
![Cognitive Service Create](/images/cog-svc-create.PNG)

2. After it creates, make a note of the Access Key and the Endpoint URL as we will use that in the code.

3. In the application itself we are going to make a modification to the ```ImageContentProvider class. We will add this following method (replacing the access key and endpoint url):

```csharp
static async Task<string> AnalyzeImage(string imageUrl)
{
    HttpClient client = new HttpClient();
    client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", "<access_key>");

    string requestParameters = "visualFeatures=Description&language=en";

    var uriBase = "<api_endpoint>";

    string uri = uriBase + "/analyze?" + requestParameters;

    HttpResponseMessage response;
    string body = "{\"url\":\"" + imageUrl + "\"}";
    response = await client.PostAsync(uri, new StringContent(body, Encoding.UTF8, "application/json")).ConfigureAwait(continueOnCapturedContext: false);;

    string contentString = await response.Content.ReadAsStringAsync().ConfigureAwait(continueOnCapturedContext: false);

    return caption;
}
```

4. Find the method ```GetCollapsibleContent and update the bottom of the method to look like this:

```csharp
string contentString = await AnalyzeImage(imageUrl).ConfigureAwait(continueOnCapturedContext: false);
dynamic converted = JsonConvert.DeserializeObject<dynamic>(contentString);
caption = converted["description"]["captions"][0].text.ToString();

return new ContentProviderResult()
{
    Content = String.Format(format+"<p>"+caption+"</p>", Microsoft.Security.Application.Encoder.HtmlAttributeEncode(href),
                                    Microsoft.Security.Application.Encoder.HtmlAttributeEncode(imageUrl)),
    Title = href
};
```

5. Now when you upload an image it should call out to the service to automatically caption it with a description.
![Caption image](/images/image-caption.gif)


-------------

## Scaling out

If you want to scale out you will need to leverage a backplane for SignalR messaging. Out of the box you can use either SQL Server service broker or Service Bus. To use Azure Service Bus follow these steps:

1. Go to the Azure Portal and create a new Azure Service Bus.
2. From the newly created Service Bus grab the connection string.
3. In the Application Settings create the following two entries:
    a. jabbr:serviceBusConnectionString and set the value to the connection string value
    b. jabbr:serviceBusTopicPrefix and set this to a prefix of your choosing (e.g. jabbr_)