import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "placeholder" ]

  connect(){
    import("leaflet").then( leaflet => {
      const polygonPoints = JSON.parse(this.element.dataset.polygonPoints);
      const centroid = JSON.parse(this.element.dataset.centroid);

      this.map = leaflet.map(this.placeholderTarget, { zoomDelta: 0.5, zoomSnap: 0.5 }).setView(centroid, 10)

      leaflet.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      }).addTo(this.map)

      leaflet.polygon(polygonPoints).addTo(this.map)
    })
  }

  disconnect(){
    this.map.remove()
  }

}
