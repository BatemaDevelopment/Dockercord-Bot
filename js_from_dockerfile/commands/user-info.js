const { SlashCommandBuilder } = require(`@discordjs/builders`);
const { MessageEmbed } = require(`discord.js`);

module.exports = {
  data: new SlashCommandBuilder()
    .setName(`user`)
    .setDescription(`Display info about yourself!`),
  async execute(interaction) {
    const userInfo = new MessageEmbed()
      .setColor(`BLACK`)
      .setTitle(`**User Info**`)
      .addFields(
        { name: `Your username:`, value: `${interaction.user.tag}`, inline: true },
        { name: `Your ID:`, value: `${interaction.user.id}`, inline: true },
      )
      .setThumbnail(interaction.user.displayAvatarURL())
      .setFooter(`Bot Creator: BatemaDevelopment#0019 | BatemaDevelopment | Lukas Batema`)
      .setTimestamp();

    interaction.reply({ embeds: [userInfo] });
  },
};