﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mnd.Domain
{
    public abstract class AbstractUseCase
    {
        public abstract void Execute();
    }

    public abstract class AbstractUseCase<T>
    {
        public abstract T Execute();
    }
}
