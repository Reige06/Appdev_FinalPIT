import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  base: '/AppDev-frontend-reactjs/',  
  plugins: [react()],

})