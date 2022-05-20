var gForm = null;

function createForm(json, data) {
  Formio.createForm(document.getElementById("formio"), json).then((form) => {
    gForm = form;

    form.on("change", (component, value) => {
      let jsonData = JSON.stringify(form.submission.data);
      window.formUpdated.postMessage(jsonData);
    });
  });
}

function updateForm(json, data) {
  gForm.form = json;
}
