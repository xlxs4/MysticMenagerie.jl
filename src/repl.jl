const PRELUDE = """

  ▄▄▄▄███▄▄▄▄   ▄██   ▄      ▄████████     ███      ▄█   ▄████████ 
▄██▀▀▀███▀▀▀██▄ ███   ██▄   ███    ███ ▀█████████▄ ███  ███    ███ 
███   ███   ███ ███▄▄▄███   ███    █▀     ▀███▀▀██ ███▌ ███    █▀  
███   ███   ███ ▀▀▀▀▀▀███   ███            ███   ▀ ███▌ ███        
███   ███   ███ ▄██   ███ ▀███████████     ███     ███▌ ███        
███   ███   ███ ███   ███          ███     ███     ███  ███    █▄  
███   ███   ███ ███   ███    ▄█    ███     ███     ███  ███    ███ 
 ▀█   ███   █▀   ▀█████▀   ▄████████▀     ▄████▀   █▀   ████████▀  


███╗   ███╗███████╗███╗   ██╗ █████╗  ██████╗ ███████╗██████╗ ██╗███████╗
████╗ ████║██╔════╝████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗██║██╔════╝
██╔████╔██║█████╗  ██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝██║█████╗  
██║╚██╔╝██║██╔══╝  ██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗██║██╔══╝  
██║ ╚═╝ ██║███████╗██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║██║███████╗
╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝

"""
const PROMPT = ">> "

function start_repl()
    println(PRELUDE)
    env = Environment()
    while true
        print(PROMPT)
        line = readline()
        isempty(line) && break

        l = Lexer(line)
        p = Parser(l)
        program = parse_program!(p)

        if !isempty(p.errors)
            println(ErrorObj(ErrorException("parser has $(length(p.errors)) error$(length(p.errors) == 1 ? "" : "s")")))
            println(join(map(string, p.errors), "\n"))
            continue
        end

        evaluated = evaluate(program, env)
        if !isnothing(evaluated)
            println(evaluated)
        end
    end
end
