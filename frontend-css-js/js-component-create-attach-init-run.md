# Методы компонента JS: create / configure / attach / init / run...

## TODO

Похоже, вопрос придется доформулировать. Потому что я вижу, что непонятна проблема. Даже больше - когда компонент один,
проблемы вообще нет. Проблема вырастает, когда появляется несколько компонентов, и они друг от друга зависят,
и ещё реагируют на действия пользователя, и возникает цепная зависимость. Вот тогда появляется вопрос,
в каком порядке их создавать, конфигурировать, инициализировать и запускать. Ведь во время инициализации компонент может 
что-то спросить у другого компонента. Или не может? А когда тогда может? Вот это и непонятно.

Пример - поле формы. Его создаёт и инициализирует компонент формы. Реализация классическая - html выдает бекенд,
JS навешивается на него. Поле реагирует на изменения других полей (например, может самозадизаблиться при изменении другого поля),
также компоненты других полей могут спросить его о состоянии - типа, а ты задизаблено?

(еще пример - textarea и строка под ней с подсчетом кол-ва введенных / оставшихся символов)

## Суть вопроса

Допустим, у нас есть JS-компонент (работает с некоторым HTML на странице, например с полем формы - обеспечивает
работу input, hint, валидацию, переключение состояний error/success, disabled/readonly и show/hide по запросам
от других компонентов и т. п.)

Его нужно перед использованием (перед работой с ним из других компонентов и перед предоставлением пользователю возможности
взаимодействия с элементом) подготовить. 

**Вопрос:** как распределить действия подготовки между методами компонента?

Ведь нужно: 

 1. Создать инстанс компонента.
 2. Сконфигурировать его (передать ему селектор, например).
 3. Проинициализировать его (он должен тут что-то сделать, но что - пока непонятно). Для взаимодействующих с ним компонентов
    после этого что-то изменится - смогут они с ним работать или еще нет? Можно ли уже показать инпут пользователю?
 4. Запустить его? Что он должен делать в процессе запуска? Каким он станет после запуска? Тождественно это инициализации или нет?

Варианты называний методов: `create() / configure() / attach() / init() / run() ...`

В чем разница между этими шагами, нужны ли они все, что делает каждый, каких каждый требует аргументов и в каком состоянии
оставляет инстанс?

## Набросочный предварительный ответ для обсуждения

 * `create() / createInstance()` - создаёт объект, ничего не делает (разве что может установить конфигурацию в конструкторе),
   после create инстанс еще не целостный и не может работать, нельзя вызывать его рабочие методы, но можно вызывать
   конфигурирующие.
 * `init()` - готовит инстанс к работе, аттачит к элементу (уже можно получить инстанс через `data` элемента). После этого можно 
   вызывать рабочие методы, но он пока не реагирует на события.
 * `attach()` - частный случай init, лучше использовать init.
 * `run()` - привязывается к событиям и в целом начинает реагировать на ситуацию сам без дерганья его методов вручную.

## Пример компонента

```js
/*
 * myExample
 */
;(function () {
  "use strict"

  $.extend(true, window, {MyApp: {components: {}})

  if (window.MyApp.components.myExample) {
    return
  }

  window.MyApp.components.myExample = {}

  window.MyApp.components.myExample.createInstance = function (params) {
    var exports

    var self = {
      $container: null,

      settings: {},

      configure: function(params) {
      	// засовываем params в self.settings как-нибудь
      },

      init: function() {
      	// запихиваемся в data-атрибут для последующего обнаружения ищущими
      	self.$container.data('myExample', exports)

      	// еще что-нибудь инициализируем, парсим там данные конфигов,
      	// обнаруживаем другие компоненты или еще что

      	return exports
      },

      run: function () {
      	self.$container.on('change', function() {
      		console.log('change happened')
      	})

      	// как-нибудь делаем наш элемент видимым пользователю

        return exports
      },

    }

    if (params) {
      $.extend(self, params)
    }

    // public
    exports = {
      run: self.run,
    }

    return exports
  }

}());
```