import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }


// Added on 8/11/2022 because it's the only thing that would let my javascript work the way I expect
// https://dev.to/nejremeslnici/using-hotwire-turbo-in-rails-with-legacy-javascript-17g1
//import { Turbo } from "@hotwired/turbo-rails"
//Turbo.session.drive = false
