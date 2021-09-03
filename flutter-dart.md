
## Dart is a single-threaded programming language
By design, Dart is a **single-threaded** programming language. That’s mean we have asynchronous code across application. When a program starts, it creates something that is called Isolate. When isolated created, the microtask manager executes all events asynchronously. 

## what is Isolate
Isolate is something where all Dart program runs. It has a piece of memory and runs a single thread. In a programming language like Java, developers can create multiple threads and share the same memory,  but Isolate is not.

Isolates have one limitation — **sharing memory between two isolates is not possible**. 

Despite that, Isolates able so send messages to each other via Port.

## Each isolate including an event loop and two event queues,

**Event loop**
The event loop is kind of like an infinite queue or loop, which runs forever. Example: create an async function and call it. at the point of time what Event loop contains is this sequence of information.

1. return an output of the method i.e. Future
2. run async function synchronously up to the first await keyword.
3. wait for that async function to finish and execute the remaining code.

**Event queue** contains all outside events: I/O, mouse events, drawing events, timers, messages between Dart isolates, and so on.

**Microtask queue** event-handling code sometimes needs to complete a task later, but before returning control to the event loop. All of the actions in Microtask Queue will  be executed before the Event Queue turn.


## How to schedule a task
When you need to specify some code to be executed later, you can use the following APIs provided by the dart:async library:

1. The Future class, which adds an item to the end of the event queue.
2. The top-level scheduleMicrotask() function, which adds an item to the end of the microtask queue.

## Use the appropriate queue (usually: the event queue)
Whenever possible, schedule tasks on the event queue, with Future. Using the event queue helps keep the the microtask queue short, reducing the likelihood of the microtask queue starving the event queue.

If a task absolutely must complete before any items from the event queue are handled, then you should usually just execute the function immediately. If you can’t, then use scheduleMicrotask() to add an item to the microtask queue. For example, in a web app use a microtask to avoid prematurely releasing a js-interop proxy or ending an IndexedDB transaction or event handler.

## Event queue: new Future()
To schedule a task on the event queue, use **new Future()** or **new Future.delayed()**. These are two of the Future constructors defined in the dart:async library.

* To immediately put an item on the event queue, use new Future():
```
// Adds a task to the event queue.
new Future(() {
  // ...code goes here...
});
```

* You can add a call to then() or whenComplete() to execute some code immediately after the new Future completes. 
```
new Future(() => 21)
    .then((v) => v*2)
    .then((v) => print(v));
```

* To enqueue an item after some time elapses, use new Future.delayed():
```
// After a one-second delay, adds a task to the event queue.
new Future.delayed(const Duration(seconds:1), () {
  // ...code goes here...
});
```	

## Fun facts about Future:

1. The function that you pass into **Future’s then() method executes immediately** when the Future completes. (The function isn’t enqueued, it’s just called.)
2. If a Future is already complete before **then()** is invoked on it, then a task is added to the **microtask queue**, and that task executes the function passed into then().
3. The **Future() and Future.delayed()** constructors don’t complete immediately; they add an item to the event queue.
4. The **Future.value()** constructor completes in a microtask, similar to **#2**.
5. The **Future.sync()** constructor executes its function argument immediately and (unless that function returns a Future) completes in a microtask, similar to #2.

## Flutter Stream vs Future

**Future** is like Promise in JS or Task in c#. They are the representation of an asynchronous request. **Futures have one and only one response**. A common usage of Future is to handle HTTP calls. What you can listen to on a Future is its state. Whether it's done, finished with success, or had an error. But that's it.

**Stream** on the other hand is **a sequence of asynchronous events**, like an asynchronous Iterable - where, instead of getting the next event when you ask for it, the stream tells you that there is an event when it is ready.. This can be assimilated to a value that can change over time. It usually is the representation of web-sockets or events (such as clicks). By listening to a Stream you'll get each new value and also if the Stream had an error or completed.


