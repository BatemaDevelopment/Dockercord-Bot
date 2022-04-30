# Pull the Alpine 3.15 Docker image
FROM alpine:3.15

# Add the `npm`, `nodejs`, and `sudo` packages without caching, but upgrading alpine
RUN apk add --no-cache --upgrade npm nodejs sudo

# Add the `node` group and user, then assign the user to the group
RUN addgroup -S node && adduser -S node -G node

# Make the directory and subdirectories `/home/node/ArtyBot_Testing_Bot/node_modules`
# and change ownership recursivly to the `node` user and group
RUN mkdir -p /home/node/Docker-Discord-Bot/node_modules && chown -R node:node /home/node/Docker-Discord-Bot

# Set the working directory to `/home/node/ArtyBot_Testing_Bot`
WORKDIR /home/node/Docker-Discord-Bot

RUN npm i --save discord.js chalk pg express && npm init -y

# Copy `package.json` and `package-lock.json` to the base directory
# COPY package*.json ./

# Install the NPM packages from the "imported" `package.json` file
# RUN npm i

# Copy ownership to user and group `node`
COPY --chown=node:node . .

# Expose the port of `8080` for some reason...
EXPOSE 8080

# Run `npm start` to start up the Discord Bot
CMD [ "npm", "start" ]