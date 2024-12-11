//1.
let userName = prompt("enter your name");
alert("hello, " + uName);

//2.
let birthDate = Number(prompt("enter your date of birth"));
const year = 2024;
alert(year - bd);

//3.
let square = Number(prompt("enter the size"));
alert(square * 4);

//4.
let radius = Number(prompt("enter the radius"));
alert(2 * Math.PI * r);

//5.
let distance = Number(prompt("enter the distance"));
let time = Number(prompt("enter time"));
alert(distance / time);

//6. 
const euro = 1.5;
const dollar = 0.5;

let dollars = Number(prompt("enter count of dollars"));
alert(dollars * dollar);


//7. 
let size = Number(prompt("enter the size of card"));
alert(size / 820);

//8.
let uMoney = Number(prompt("enter the count of money"));
let chocolate = Number(prompt("enter the cost of chocolate"));
alert(Math.floor(uMoney / chocolate));
alert(uMoney % chocolate);


//9.
let num = Number(prompt("enter a number"));
let firstNum = String(num % 10);
num = Math.floor(num / 10);
let secondNum = String(num % 10);
num = Math.floor(num / 10);
let thirdNum = String(num % 1000);
let res = firstNum + secondNum + thirdNum;
alert(res);

//10.
let trueFalse = ["true", "false"];
let number = Number(prompt("enter the number"));
alert(trueFalse[number % 2])