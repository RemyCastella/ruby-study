# Scoping

CONST = "outer scope"

module A
    CONST = "inner scope"
end

module A
    class B
        def self.const
            CONST
        end
    end
end

class A::C
    def self.const
        CONST
    end
end

p A::B.const
p A::C.const

