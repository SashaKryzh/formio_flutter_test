async function createForm(json) {
  Formio.createForm(document.getElementById("formio"), json).then(function (
    form
  ) {
    form.on("change", (component, value) => {
      let jsonData = JSON.stringify(form.submission.data);
      window.formUpdated.postMessage(jsonData);
    });
  });
}
