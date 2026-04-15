import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "node:path";

// For GitHub Pages project sites set VITE_BASE_PATH=/your-repo-name/ in CI secrets or env before build.
const base = process.env.VITE_BASE_PATH?.trim() || "/";

export default defineConfig({
  base,
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src")
    }
  }
});
