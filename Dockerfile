FROM n8nio/n8n:1.90.0

USER root

# Install additional packages using Alpine's package manager
RUN apk add --no-cache \
    git \
    curl

# Set up npm global directory
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

# Switch back to node user
USER node

# Install global npm packages
RUN mkdir -p /home/node/.npm-global && \
    npm install -g npm@latest
    npm install -g @modelcontextprotocol/server-github

# Install your specific required packages here
# For example: RUN npm install -g your-package-name

# Set n8n to execute external commands
ENV NODE_FUNCTION_ALLOW_EXTERNAL=true
ENV N8N_DISABLE_PRODUCTION_MAIN_PROCESS=false
ENV N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true

WORKDIR /home/node

# Use the proper path to the n8n executable
# The n8n command is typically available in the PATH in the base image
# We'll use the shell form to check if n8n exists in current PATH
CMD ["sh", "-c", "command -v n8n && n8n start || node /usr/local/lib/node_modules/n8n/bin/n8n start"]