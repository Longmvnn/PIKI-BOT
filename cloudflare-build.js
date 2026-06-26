const fs = require("fs");

const supabaseUrl = process.env.VITE_SUPABASE_URL || "";
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || "";

fs.writeFileSync(
  "env.js",
  `window.PIKI_SUPABASE_ENV = {
  supabaseUrl: ${JSON.stringify(supabaseUrl)},
  supabaseAnonKey: ${JSON.stringify(supabaseAnonKey)}
};`
);

console.log("env.js created for Cloudflare Pages");
