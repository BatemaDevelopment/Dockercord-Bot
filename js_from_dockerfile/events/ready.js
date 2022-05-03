module.exports = {
  name: `ready`,
  once: true,
  execute(interaction) {
    console.log(`Ready! Logged in as ${interaction.user.tag}`);
  },
};