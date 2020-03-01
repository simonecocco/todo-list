require 'json'
require 'ostruct'

$save_path="data.json"

class List
    public
    def self.load_list
        return nil unless File.file?($save_path)
        list=File.read $save_path
        list=JSON.parse list
        if list.size==0
            list=[]
        else
            tmp=[]
            list.each{|i| tmp.push({:done=>i["done"],:title=>i["title"]})}
            return tmp
        end
    end

    public
    def initialize
        @list=List.load_list
        @list=[] if @list==nil
    end

    public
    def self.item title
        return {:done=>"o",:title=>title}
    end

    public
    def +(el)
        @list.push el
        return self
    end

    public
    def -(el)
        @list.delete_at el
        return self
    end

    public
    def elem?
        @list
    end

    public
    def save
        file=File.new $save_path,"w+"
        file.write JSON.generate @list
        file.close
    end

    public
    def refresh
        @list=List.load_list
        @list=[] if @list==nil
    end

    public 
    def to_s
        elem?
    end
end

$todo_list=List.new

def show
    elem=$todo_list.elem?
    if(elem.size==0)
        puts "void list"
    else
        for item in elem.size.times
            puts "(#{item}) -> [#{elem[item][:done]}] #{elem[item][:title]}"
        end
    end
end

def done
    $todo_list.elem?[ARGV[1].to_i][:done]="x"
    $todo_list.save
end

def add
    phrase=ARGV
    phrase.delete_at 0
    text=""
    for word in phrase
        text+="#{word} "
    end
    item=List.item text
    $todo_list+item
    $todo_list.save
end

def clear
    index=[]
    for elem in $todo_list.elem?
        next if(elem[:done].eql?("o"))
        index.push($todo_list.elem?.index elem)
    end
    tmp=0
    for i in index
        $todo_list-(i-tmp)
        tmp+=1
    end
    $todo_list.save
end

def reset
    File.delete "data.json"
end


case ARGV[0]
when "do"
    done
when "new"
    add
when "clear"
    clear
when "reset"
    reset
else
    show
end
