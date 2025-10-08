import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tubes-cursor"
export default class extends Controller {
  static targets = ["canvas"]
  static values = { 
    colors: Array,
    lightColors: Array,
    intensity: Number
  }

  connect() {
    console.log("TubesCursor controller connected")
    this.loadTubesLibrary()
  }

  disconnect() {
    if (this.tubesApp) {
      // Clean up WebGL context if possible
      try {
        this.tubesApp.dispose?.()
      } catch (error) {
        console.warn("Error disposing tubes app:", error)
      }
    }
  }

  async loadTubesLibrary() {
    try {
      this.element.classList.add('loading')

      // Load the library via script tag for better compatibility
      const script = document.createElement('script')
      script.type = 'module'
      script.textContent = `
        import TubesCursor from "https://cdn.jsdelivr.net/npm/threejs-components@0.0.22/build/cursors/tubes1.min.js";
        window.TubesCursor = TubesCursor;
        window.dispatchEvent(new CustomEvent('tubesCursorLoaded'));
      `

      document.head.appendChild(script)

      // Wait for the library to load
      window.addEventListener('tubesCursorLoaded', () => {
        this.initializeTubes(window.TubesCursor)
      }, { once: true })

    } catch (error) {
      console.error("Failed to load TubesCursor library:", error)
      this.handleError()
    }
  }

  initializeTubes(TubesCursor) {
    try {
      // Default configuration
      const defaultColors = ["#f967fb", "#53bc28", "#6958d5"]
      const defaultLightColors = ["#83f36e", "#fe8a2e", "#ff008a", "#60aed5"]
      const defaultIntensity = 200

      // Use provided values or defaults
      const colors = this.hasColorsValue ? this.colorsValue : defaultColors
      const lightColors = this.hasLightColorsValue ? this.lightColorsValue : defaultLightColors
      const intensity = this.hasIntensityValue ? this.intensityValue : defaultIntensity

      // Initialize the tubes cursor
      this.tubesApp = TubesCursor(this.canvasTarget, {
        tubes: {
          colors: colors,
          lights: {
            intensity: intensity,
            colors: lightColors
          }
        }
      })

      this.element.classList.remove('loading')
      this.setupInteractions()
      
      console.log("TubesCursor initialized successfully")
    } catch (error) {
      console.error("Failed to initialize TubesCursor:", error)
      this.handleError()
    }
  }

  setupInteractions() {
    // Add click interaction to change colors
    this.element.addEventListener('click', this.changeColors.bind(this))

    // Add keyboard interaction
    document.addEventListener('keydown', this.handleKeyPress.bind(this))
  }

  changeColors() {
    if (!this.tubesApp) return

    try {
      const newColors = this.generateRandomColors(3)
      const newLightColors = this.generateRandomColors(4)
      
      console.log("Changing colors:", newColors, newLightColors)
      
      this.tubesApp.tubes.setColors(newColors)
      this.tubesApp.tubes.setLightsColors(newLightColors)
    } catch (error) {
      console.warn("Error changing colors:", error)
    }
  }

  handleKeyPress(event) {
    // Change colors on spacebar press
    if (event.code === 'Space' && event.target === document.body) {
      event.preventDefault()
      this.changeColors()
    }
  }

  generateRandomColors(count) {
    return new Array(count)
      .fill(0)
      .map(() => "#" + Math.floor(Math.random() * 16777215).toString(16).padStart(6, '0'))
  }

  handleError() {
    this.element.classList.remove('loading')
    this.element.classList.add('error')

    // Show fallback content
    this.canvasTarget.style.display = 'none'
    console.warn("TubesCursor failed to load, showing fallback")
  }

  // Action methods that can be called from the view
  randomizeColors() {
    this.changeColors()
  }

  setCustomColors(colors, lightColors) {
    if (!this.tubesApp) return

    try {
      if (colors) this.tubesApp.tubes.setColors(colors)
      if (lightColors) this.tubesApp.tubes.setLightsColors(lightColors)
    } catch (error) {
      console.warn("Error setting custom colors:", error)
    }
  }
}
