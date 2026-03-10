import { useState } from "react"

export const ToDo = () =>{
    const [todos, setTodos] = useState([])
    const [isEditing, setIsEditing] = useState(false)
    const [currentTodo, setCurrentTodo] = useState(null)
    const [currentTitle, setcurrentTitle]= useState('')
    const[currentDescription, setCurrentDescription] = useState('')

    // type Todo
    // {
    //     id: Number,
    //     title: String,
    //    description: string,
    //     completed: Boolean
    // }
    //todos: Todo[]
        
    
    const addTask =()=>{
        setTodos((prev)=>{
            [...prev, {id: todos.length + 1, title: currentTitle, description: currentDescription, completed: false}]
        })
        setcurrentTitle('')
        setcurrentDescription('')
    }

    const removeTask = (todoToRemove) =>{
        const updatedTodos = todos.filter((todo)=> todo.id !== todoToRemove.id)
        setTodos(updatedTodos)
    }

    const updateTask = () =>{
            if(!currentTodo) return console.alert('Item not found')
            
            updatedTodo = {
                ...currentTodo,
                title: currentTitle,
                description: currentDescription
            }
            
        const rest = todos.filter((item)=> item.id !== currentTodo.id)
        setTodos([...rest, updatedTodo])
        setCurrentTodo(null)
    
    }

    const toggleTodo = () =>{
        if(!currentTodo) return console.alert('Item not found')
        
        updatedTodo = {
            ...currentTodo,
            completed: !currentTodo.completed
        }
        const rest = todos.filter((item)=> item.id !== currentTodo.id)
        setTodos([...rest, updatedTodo])
        setCurrentTodo(null)
    }

    return(
            <div>
                Tasks:
                <ul>
                {todos.map((todo) => {
                    <li>
                        {`${todo.id}:  ${todo.title} -  ${todo.description}`}
                        <input type="checkbox"
                        checked={todo.completed}
                        onClick={()=>{
                                setCurrentTodo(todo)
                                toggleTodo()
                                }
                        }/>
                        {/* or */}
                        <button onClick={()=> {
                                    setCurrentTodo(todo)
                                    toggleTodo()
                            }}>
                            {todo.completed? 'Reopen task' : 'Mark Completed'} 
                        </button>
                        <button onClick={removeTask(todo)}
                        >
                            Delete
                        </button>
                        <button onClick={()=> {
                                    setCurrentTodo(todo)
                                    setcurrentTitle(todo.title)
                                    setIsEditing(true)
                     } }>Edit T
                        </button>
                      {isEditing && (<div>
                                 <input type="text" value={currentTitle} onChange={(val)=> setcurrentTitle(val)}/>
                                <input type="text" value={currentDescription} onChange={(val)=> setcurrentDescription(val)}></input>
                                 <button onClick={updateTask()}>Save</button>
                        </div>)
                    }
                    <button onClick={()=> {
                                    setCurrentTodo(todo)
                                    toggleTodo()
                            }}>
                            {todo.completed? 'Reopen task' : 'Mark Completed'} 
                        </button>
                        
                    </li>
                })}
                </ul>
                
                <input type="text" value={currentTitle} onChange={(val)=> setcurrentTitle(val)}></input>
                <input type="text" value={currentDescription} onChange={(val)=> setcurrentDescription(val)}></input>
                <button onClick={addTask}>Add a new Task</button>
            </div>
     )
        
}