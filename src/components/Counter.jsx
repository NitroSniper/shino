import { createSignal } from 'solid-js';


export function Counter() {

  const [count, setCount] = createSignal(0);

  return (
    <div> <h1> Count is {count()} </h1> <button onClick={() => setCount(count() + 1)}>Add</button>
    </div>
  )
}
