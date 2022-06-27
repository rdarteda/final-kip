import ItemsController from "./itemsController";

const product1 = {
  id: 1,
  name: "Tayto",
  description: "Cheese & Onion Chips",
  img: "https://www.irishtimes.com/polopoly_fs/1.4078148!/image/image.jpg",
  createdAt: "2020-09-20",
};

function addItemCard(item) {
  const product = new ItemsController();
  const name = item.name;
  const desc = item.description;
  console.log(product1);
  //   product.items.push(item);
  product.addItem(name, desc);
  console.log(product);
  return product.items;
}

console.log(addItemCard(product1.description));
