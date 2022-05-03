const fs = require(`fs`);

const { Client, Collection, Intents } = require(`discord.js`);
const { REST } = require(`@discordjs/rest`);
const { Routes } = require(`discord-api-types/v9`);

const config = require(`./config.js`).config;
const { clientId, guildId, token } = JSON.parse(JSON.stringify(config));

const client = new Client({ intents: [Intents.FLAGS.GUILDS] });

const eventFiles = fs.readdirSync(`./events`).filter(file => file.endsWith(`.js`));

for (const file of eventFiles) {
  const event = require(`./events/${file}`);
  if (event.once) {
    client.once(event.name, (...args) => event.execute(...args));
  } else {
    client.on(event.name, (...args) => event.execute(...args));
  }
}

client.commands = new Collection();
const commandFiles = fs.readdirSync(`./commands`).filter(file => file.endsWith(`.js`));

for (const file of commandFiles) {
  const command = require(`./commands/${file}`);
  client.commands.set(command.data.name, command);
}

client.on(`interactionCreate`, async interaction => {
  if (!interaction.isCommand()) return;

  const command = client.commands.get(interaction.commandName);

  if (!command) return;

  try {
    await command.execute(interaction);
  } catch (error) {
    console.error(error);
    return interaction.reply({ content: `There was an error while executing this command`, ephemeral: true });
  }
});

const commands = [];

for (const file of commandFiles) {
  const command = require(`./commands/${file}`);
  commands.push(command.data.toJSON());
}

const rest = new REST({ version: `9` }).setToken(token);

rest.put(Routes.applicationGuildCommands(clientId, guildId), { body: commands })
	.then(() => console.log(`Successfully registered application commands.`))
	.catch(console.error);

client.login(token);