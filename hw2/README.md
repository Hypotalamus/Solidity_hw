### **2ое практическое задание : Реализовать контракт ICO по продаже токенов**

Контракт должен содержать

- токен с произвольным именем, символов, кол-во знаков после запятой 18
    - hardcap токенов,устанавливающей максимальной кол-во токенов
- функцию покупки токена
    - принимающую в качестве оплаты эфир
    - создающая токены через функцию mint токенов
    - отправляющая  эфир создателю контракта
    - начисляющие пользователю токены по курсу покупки, установленному в отдельной переменной
    - проверяющей что не превышен hard cap токенов
- возможность закончить ICO,вызывать может только владелец контракта, приостанавливает прием денег от пользователей