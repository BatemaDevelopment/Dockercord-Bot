# Pull the Alpine 3.15 Docker image
FROM alpine:3.15

# Add the `npm`, `nodejs`, and `sudo` packages without caching, but upgrading Alpine
RUN apk add --no-cache --upgrade npm nodejs sudo

# Add the `node` group and user, then assign the user to the group
RUN addgroup -S node && adduser -S node -G node

# Make the directory and subdirectories `/home/node/Docker-Discord-Bot/node_modules`
# and change ownership recursivly to the `node` user and group
RUN mkdir -p /home/node/Docker-Discord-Bot/node_modules && chown -R node:node /home/node/Docker-Discord-Bot

# Make the required directories for the bot
RUN mkdir -p /home/node/Docker-Discord-Bot/events && chown -R node:node /home/node/Docker-Discord-Bot/events
RUN mkdir -p /home/node/Docker-Discord-Bot/commands && chown -R node:node /home/node/Docker-Discord-Bot/commands

# Set the working directory to `/home/node/Docker-Discord-Bot`
WORKDIR /home/node/Docker-Discord-Bot

# Install required NPM Packages
RUN npm i --save discord.js @discordjs/builders @discordjs/rest discord-api-types chalk pg express && npm init -y

# Add JS and other files below to make the bot run
RUN sudo -S echo ' \
const fs = require(`fs`); \
\
const { Client, Collection, Intents } = require(`discord.js`); \
const { REST } = require(`@discordjs/rest`); \
const { Routes } = require(`discord-api-types/v9`); \
\
const config = require(`./config.js`).config; \
const { clientId, guildId, token } = JSON.parse(JSON.stringify(config)); \
\
const client = new Client({ intents: [Intents.FLAGS.GUILDS] }); \
\
const eventFiles = fs.readdirSync(`./events`).filter(file => file.endsWith(`.js`)); \
\
for (const file of eventFiles) { \
  const event = require(`./events/${file}`); \
  if (event.once) { \
    client.once(event.name, (...args) => event.execute(...args)); \
  } else { \
    client.on(event.name, (...args) => event.execute(...args)); \
  } \
} \
\
client.commands = new Collection(); \
const commandFiles = fs.readdirSync(`./commands`).filter(file => file.endsWith(`.js`)); \
\
for (const fileCMD of commandFiles) { \
  const commandCMD = require(`./commands/${fileCMD}`); \
  client.commands.set(commandCMD.data.name, commandCMD); \
} \
\
client.on(`interactionCreate`, async interaction => { \
  if (!interaction.isCommand()) return; \
\
  const commandInteraction = client.commands.get(interaction.commandName); \
\
  if (!commandInteraction) return; \
\
  try { \
    await commandInteraction.execute(interaction); \
  } catch (error) { \
    console.error(error); \
    return interaction.reply({ content: `There was an error while executing this command`, ephemeral: true }); \
  } \
}); \
\
const commands = []; \
\
for (const file of commandFiles) { \
  const command = require(`./commands/${file}`); \
  commands.push(command.data.toJSON()); \
} \
\
const rest = new REST({ version: `9` }).setToken(token); \
\
rest.put(Routes.applicationGuildCommands(clientId, guildId), { body: commands }) \
	.then(() => console.log(`Successfully registered application commands.`)) \
	.catch(console.error); \
\
client.login(token); \
' >/home/node/Docker-Discord-Bot/index.js

RUN sudo -S echo ' \
module.exports = { \
  config: { \
    clientId: process.env.CLIENT_ID, \
    guildId: process.env.GUILD_ID, \
    token: process.env.DISCORD_TOKEN \
  }, \
}; \
' >/home/node/Docker-Discord-Bot/config.js

RUN sudo -S echo ' \
module.exports = { \
  name: `interactionCreate`, \
  execute(interaction) { \
    console.log(`${interaction.user.tag} in #${interaction.channel.name} triggered an interaction`); \
  }, \
}; \
' >/home/node/Docker-Discord-Bot/events/interactionCreate.js

RUN sudo -S echo ' \
module.exports = { \
  name: `ready`, \
  once: true, \
  execute(interaction) { \
    console.log(`Ready! Logged in as ${interaction.user.tag}`); \
  }, \
}; \
' >/home/node/Docker-Discord-Bot/events/ready.js

RUN sudo -S echo ' \
const { SlashCommandBuilder } = require(`@discordjs/builders`); \
const { MessageEmbed } = require(`discord.js`); \
\
module.exports = { \
  data: new SlashCommandBuilder() \
    .setName(`user`) \
    .setDescription(`Display info about yourself!`), \
  async execute(interaction) { \
    const userInfo = new MessageEmbed() \
      .setColor(`BLACK`) \
      .setTitle(`**User Info**`) \
      .addFields( \
        { name: `Your username:`, value: `${interaction.user.tag}`, inline: true }, \
        { name: `Your ID:`, value: `${interaction.user.id}`, inline: true }, \
      ) \
      .setThumbnail(interaction.user.displayAvatarURL()) \
      .setFooter(`Bot Creator: BatemaDevelopment#0019 | BatemaDevelopment | Lukas Batema`) \
      .setTimestamp(); \
\
    interaction.reply({ embeds: [userInfo] }); \
  }, \
}; \
' >/home/node/Docker-Discord-Bot/commands/user-info.js

RUN sudo -S echo ' \
const { SlashCommandBuilder } = require(`@discordjs/builders`); \
const { MessageEmbed } = require(`discord.js`); \
\
module.exports = { \
  data: new SlashCommandBuilder() \
    .setName(`server`) \
    .setDescription(`Display info about this server!`), \
  async execute(interaction) { \
    const serverInfo = new MessageEmbed() \
      .setColor(`BLACK`) \
      .setTitle(`**Server Info**`) \
      .addFields( \
        { name: `Server name:`, value: `${interaction.guild.name}`, inline: true }, \
        { name: `Total members:`, value: `${interaction.guild.memberCount}`, inline: true }, \
      ) \
      .setThumbnail(interaction.guild.iconURL()) \
      .setFooter(`Bot Creator: BatemaDevelopment#0019 | BatemaDevelopment | Lukas Batema`) \
      .setTimestamp(); \
\
    interaction.reply({ embeds: [serverInfo] }); \
  }, \
}; \
' >/home/node/Docker-Discord-Bot/commands/server-info.js

# Copy ownership to user and group `node`
COPY --chown=node:node . .

# Debugging
# RUN node -v
# RUN npm list

# Run `node index` to start up the Discord Bot
CMD [ "node", "--trace-warnings", "--trace-deprecation", "index.js" ]