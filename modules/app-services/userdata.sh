#!/bin/bash

# Exit immediately on error, undefined variable use, or failed pipe
set -euo pipefail

# Use noninteractive frontend for apt to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# --- 1. Update and install basic dependencies ---
echo "Starting installation..."
apt-get update -y
apt-get upgrade -y
apt-get install -y curl git nginx unzip

# --- 2. Install Node.js (18 LTS) ---
# The default repo may have older Node; use official NodeSource setup
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# --- 3. Create the Node.js application (dummy app) ---
# Create app directory
mkdir -p /var/www/myapp
cd /var/www/myapp

# Initialize project
npm init -y

# Install Express (simple web framework)
npm install express

# CREATE THE SERVER FILE (server.js) ON THE FLY
# Ensures something runs even without a git clone
cat <<'EOF' > server.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({ 
    status: 'Running',
    message: 'Hello from AWS EC2 + Terraform!',
    timestamp: new Date()
  });
});

app.get('/health', (req, res) => {
  res.send('OK');
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
EOF

# --- 4. Configure systemd (ensure app runs on reboot) ---
# Ensures Node restarts if the instance reboots
cat <<'EOF' > /etc/systemd/system/myapp.service
[Unit]
Description=Node.js App
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/www/myapp
ExecStart=/usr/bin/node server.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the service
systemctl daemon-reload
systemctl enable --now myapp

# --- 5. Configure Nginx (reverse proxy) ---
# Forward port 80 (public) to 3000 (Node app)
# Remove default site if present (no error if missing)
rm -f /etc/nginx/sites-enabled/default

cat <<'EOF' > /etc/nginx/sites-available/myapp
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Symlink the site config (force to avoid duplicate link errors) and restart nginx
ln -sf /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/
systemctl restart nginx

echo "Installation completed successfully!"