const { SlashCommandBuilder } = require(`@discordjs/builders`);
const { MessageEmbed } = require(`discord.js`);

module.exports = {
  data: new SlashCommandBuilder()
    .setName(`server`)
    .setDescription(`Display info about this server!`),
  async execute(interaction) {
    const serverInfo = new MessageEmbed()
      .setColor(`BLACK`)
      .setTitle(`**Server Info**`)
      .addFields(
        { name: `Server name:`, value: `${interaction.guild.name}`, inline: true },
        { name: `Total members:`, value: `${interaction.guild.memberCount}`, inline: true },
      )
      .setThumbnail(interaction.guild.iconURL())
      .setFooter(`Bot Creator: BatemaDevelopment#0019 | BatemaDevelopment | Lukas Batema`)
      .setTimestamp();

    interaction.reply({ embeds: [serverInfo] });
  },
};