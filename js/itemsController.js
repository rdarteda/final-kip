export default class ItemsController {
  constructor(currentId = 0) {
    this.items = [];
    this.currentId = currentId;
  }

  addItem(name, description) {
    const item = {
      id: this.currentId++,
      name: name,
      description: description,
    };

    this.items.push(item);
  }
}
const item1 = new ItemsController();
item1.addItem("name1", "descroption1");
console.log(item1.items[0].id);
console.log(item1.items[0].name);
