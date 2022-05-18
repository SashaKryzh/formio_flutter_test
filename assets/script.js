window.onload = function () {
  Formio.createForm(document.getElementById("formio"), {
    components: [
      {
        label: "Text Field",
        tableView: true,
        key: "textField",
        type: "textfield",
        input: true,
      },
      {
        label: "Number",
        mask: false,
        tableView: false,
        delimiter: false,
        requireDecimal: false,
        inputFormat: "plain",
        truncateMultipleSpaces: false,
        key: "number",
        type: "number",
        input: true,
      },
      {
        type: "button",
        label: "Submit",
        key: "submit",
        disableOnInvalid: true,
        input: true,
        tableView: false,
      },
    ],
  });
};
