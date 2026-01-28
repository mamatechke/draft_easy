module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/components/**/*.html.erb',
    './app/components/**/*.rb',
    './app/content/**/*.html.*',
    './lib/markdown_rails/**/*.rb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './config/initializers/**/*.rb'
  ],
  theme: {
    container: {
      center: true,
      padding: {
        DEFAULT: '1rem',
        sm: '1rem'
      }
    }
  },
  daisyui: {
    themes: [
      {
        drafteasy: {
          'primary': '#420f8e',
          'secondary': '#c7a8f4',
          'accent': '#37cdbe',
          'neutral': '#3d4451',
          'base-100': '#ffffff',
          'info': '#2094f3',
          'success': '#009485',
          'warning': '#ff9900',
          'error': '#ff5724',
        },
      },
      'light',
      'dark',
    ],
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('daisyui')
  ]
}
