You will need to supply your own Discord Bot Token (found at https://discord.com/developers/), Client ID (found once you create a Discord Application), and Guild ID (found when you enable Developer Mode in Discord Settings in the Main Client, then copy your server, which is also known as a guild, ID). Other than that, this Dockerfile is usable OOTB (out of the box).

- Docker Hub: https://hub.docker.com/repository/docker/lukasbatema/docker-discord-bot

# How to Create a Discord Bot, Add it To Your Server, and Get it Running
To create the bot you will want to go to https://discord.com/developers/. To create an application, which we want to do, click, `New Application`.
<br>
Now once we have it created, we will want to create the bot. We do this by heading over to the `Bot` tab (found on the left side bar of the site) and click `Add Bot`.
<br>
Now we will add the permissions we need. head on over to `OAuth2 -> URL Generator`. The below picture will tell you what permissions we will need.
<br>
<img src="tutorial_images/OAuth2Permissions.png" />
<br>
Be sure to copy the link!
<br>
<img src="tutorial_images/OAuth2GeneratedURLCopyButton.png" />
<br>
Next, we will head over to `OAuth2 -> General`. Click `Add Redirect`. Paste the link copied earlier into the box. Then paste it into your search bar in a browser and hit return.
<br>
<img src="tutorial_images/AddOAuth2Redirect.png" />
<br>
<img src="tutorial_images/PasteOAuth2URL.png" />
<br>
<img src="tutorial_images/PasteOAuthURLIntoSearchBar.png" />
<br>
Now we want to add our bot to the server of choice. Follow the next images to do so.
<br>
<img src="tutorial_images/AddBotToServer.png" />
<br>
<img src="tutorial_images/AuthoriseBot.png" />
<br>
Now, we want to reset the bot token. Head on over to `Bot`. Click `Reset Token`.
<br>
<img src="tutorial_images/ResetToken.png" />
<br>
Copy it, and paste it into the `<INSERT_BOT_TOKEN>` spot in the following image.
<br>
<img src="tutorial_images/InsertIDs.png" />
<br>
Copy the Bot ID by right clicking on it's profile and clicking `Copy ID`, do so with the server you added it into as well.
<br>
<img src="tutorial_images/CopyBotID.png" />
<br>
<img src="tutorial_images/CopyServerID.png" />
<br>
Paste them into the `<INSERT_GUILD_ID>` and `<INSERT_CLIENT_ID>` spots respectively.
<br>
Now you can use my referral link (https://railway.app?referralCode=BatemaDevelopment) to sign up for the best Cloud Hosting Service, so you can deploy your Discord Bot 24/7 (until you run out of your $5.00 (USD) credits for the month). CONGRATS! You just deployed your Discord Bot! I hope you enjoy!