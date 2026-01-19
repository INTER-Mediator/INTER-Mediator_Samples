function showPanel() {
  document.getElementById('funcpanel').style.display = 'block'
}

function hidePanel() {
  document.getElementById('funcpanel').style.display = 'none'
}

function initializeUtilityPanel() {
  hidePanel()
  const visiblePanel = document.getElementById("panelcontent")
  visiblePanel.addEventListener('click', (event) => {
    if (event.target.tagName != 'BUTTON') {
      event.stopPropagation()
    }
  })
}
