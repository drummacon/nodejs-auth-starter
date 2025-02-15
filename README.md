# nodejs-auth-starter
Real-time SPA with user authentication that includes support for 2FA, CSRF, Helmet, and JWT. This is meant to be used as a starting point when building custom auth for NodeJS applications. The app includes a frontend built with vanilla JavaScript and a backend server using Express. The app stores user data using a simple SQLite, and bundles client-side code with Webpack. 2FA works using MailHog (testing purposes only) and all setup instructions can be found below. For actual use, a real mail server  must be setup for 2FA to work correctly.

![login-ss.png](images/login-ss.png)  
*login-ss.png*

![register-ss.png](images/register-ss.png)  
*register-ss.png*

![2fa-ss.png](images/2fa-ss.png)  
*2fa-ss.png*

## Features

- User dashboard with dynamic URL generation
- Login page with secure login (JWT auth)
- Email 2FA verification pre-issued tokens
- SQLite database
- .ejs UI templates
- Helmet CSRF protection and secure HTTP headers
- Webpack config

## Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/cgtwig/nodejs-auth-starter
   cd nodejs-auth-starter
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Rename the file `.env-example` to `.env` in the project root**. Or create a new file with the contents of `.env-example` below.
   - Generate values for the blank lines (`JWT_SECRET`, `ENCRYPTION_KEY`, `ENCRYPTION_IV`, and `CSRF_SECRET`)
   ```bash
   openssl rand -hex 32   # For JWT_SECRET, ENCRYPTION_KEY, and CSRF_SECRET (generate different one for each)
   openssl rand -hex 16   # For ENCRYPTION_IV
   ```

   #### `.env-example`
   ```env
   # Server Configuration
   PORT=3000
   NODE_ENV=development
   # JWT Secret Key (Used for Authentication Tokens)
   JWT_SECRET=
   # MailHog SMTP Configuration (Local Development)
   SMTP_HOST=127.0.0.1
   SMTP_PORT=1025
   SMTP_SECURE=false
   # SQLite Database File
   DB_PATH=./database.db
   # Allowed Origins (Frontend URLs that can access the backend)
   ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
   # Allowed Hosts (Prevent Host Header Injection)
   ALLOWED_HOSTS=localhost:3000,127.0.0.1:3000
   # Encryption Keys (Generate Secure Random Values)
   ENCRYPTION_KEY=
   ENCRYPTION_IV=
   # CSRF Protection Secret
   CSRF_SECRET=
   ```
4. **2FA Setup**  
   - **Windows:**
     Download `MailHog.exe` from [MailHog Releases](https://github.com/mailhog/MailHog/releases)
   - **MacOSX/Linux:** THe best way to setup MailHog is to run this script in terminal. It will install/launch a fresh installation of MailHog on port 8025.
    
   ```bash
   # Check OS, kill any process using port 1025 (without sudo) to avoid conflicts.
   # Defines the MailHog download URL and then downlaods, sets permissions and launches web ui.
   OS=$(uname -s)
   ARCH=$(uname -m)
   if [ "$OS" = "Darwin" ]; then
       PLATFORM="macOS"
   elif [ "$OS" = "Linux" ]; then
       PLATFORM="linux"
   else
       echo "Unsupported OS. Please install MailHog manually."
       exit 1
   fi
   if [ "$ARCH" = "x86_64" ]; then
       ARCH="amd64"
   elif [ "$ARCH" = "aarch64" ]; then
       ARCH="arm"
   else
       echo "Unsupported architecture. Please install MailHog manually."
       exit 1
   fi
   https://github.com/cgtwig/nodejs-auth-starter/blob/main/README.me
   URL="https://github.com/mailhog/MailHog/releases/latest/download/MailHog_${PLATFORM}_${ARCH}"
   kill -9 $(lsof -ti:1025) 2>/dev/null || true
   mkdir -p ~/bin && wget -qO ~/bin/MailHog "$URL" && chmod +x ~/bin/MailHog && ~/bin/MailHog
   ```
   
   **Access MailHog UI** [http://0.0.0.0:8025/](http://0.0.0.0:8025/)
     
   **OR...** Mailhog can alternatively be ran with Docker using this one-liner (optional):
   ```bash
   docker run -d -p 1025:1025 -p 8025:8025 mailhog/mailhog
   ```
    [http://127.0.0.1:8025](http://127.0.0.1:8025).
   
   ![mailhog-ui-ss.png](images/mailhog-ui-ss.png)  
   *mailhog-ui-ss.png*

7. **Build client-side:**
   ```bash
   npm run build
   ```
   Webpack (`webpack.config.cjs`) for bundling client-side javascript (`src/app.js`, `public/js/script.js`, and `public/js/user-dashboard.js`) into `public/js/bundle.js`.

8. **Start server:**
   ```bash
   npm start
   ```
   Or to enable hot-reloading and live updates during development, run:
   ```bash
   npm run dev
   ```
   The app will now be available at [http://localhost:3000](http://localhost:3000).

## Technologies Used

- **Backend:** Node.js, Express, Better-SQLite3, JWT, Nodemailer (2FA)
- **Frontend:** Vanilla JavaScript, EJS templates, CSS
- **Bundling:** Webpack
- **Development Tools:** MailHog (optional)

## Troubleshooting

- **400 Bad Request on Registration:**
  Verify that all required fields (username, email, password) and the CSRF token are correctly sent. Check the request payload in your browser's Network tab.

- **SMTP Connection Issues:**
  If errors like `ECONNREFUSED` occur, ensure MailHog is running and that `SMTP_HOST` is set to `127.0.0.1`.

- **Caching Issues:**
  If client-side changes are not reflected, rebuild the bundle (`npm run build`) and clear your browser cache.

## License

MIT
