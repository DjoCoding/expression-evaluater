#ifndef EVAL_H
#define EVAL_H

#include "./astf.h"

OPERATOR_T get_operator_type(node_t node) {
    switch(node->data.value.operator) {
        case '+':
            return PLUS;
        case '-':
            return MINUS;
        case '*':
            return MULT;
        case '/':
            return DIV;
        case '%':
            return MOD;
        default:
            return PLUS;
    }
}

int evaluate(int left, int right, OPERATOR_T op) {
    switch(op) {
        case PLUS: return left + right;
        case MINUS: return left - right;
        case MULT: return left * right;
        case DIV: return left / right;
        case MOD: return left % right;
        default: 
            return 0;
    }
}

EVALUATION_RESULT generate_bad_result() {
    return (EVALUATION_RESULT) { 
        .result = 0,
        .type = ERROR
    };
}

double evaluate_function(FUNCTION_NAME func_name, double func_input) {
    switch(func_name) {
        case COS: 
            func_input = func_input * M_PI / 180;
            return cos(func_input);
        case SIN: 
            func_input = func_input * M_PI / 180;
            return sin(func_input);
        case EXP:
            return exp(func_input);
        case SQRT: 
            if (func_input < 0) return 0;
            return sqrt(func_input);
        default:
            return 0;
    }
}

EVALUATION_RESULT eval(node_t root) {
    if (!root) 
        return (EVALUATION_RESULT) { .result = 0, .type = GOOD_RESULT };

    if (root->type.type == TT_NUMBER) 
        return
            (EVALUATION_RESULT) { .result = root->data.value.number, .type = GOOD_RESULT };

    if (root->type.type == TT_FUNCTION) {
        EVALUATION_RESULT input_evaluation = eval(root->left);
        if (input_evaluation.type == GOOD_RESULT) 
            return (EVALUATION_RESULT)
            { .result = evaluate_function(root->data.value.func_name, input_evaluation.result), .type = GOOD_RESULT };
        else 
            return generate_bad_result();
    } 

    EVALUATION_RESULT left_evaluation = eval(root->left);
    if(left_evaluation.type == ERROR) 
        return left_evaluation;

    EVALUATION_RESULT right_evaluation = eval(root->right);
    if(right_evaluation.type == ERROR) 
        return right_evaluation;

    return 
        (EVALUATION_RESULT) {
            .type = GOOD_RESULT,
            .result = evaluate(left_evaluation.result, right_evaluation.result, get_operator_type(root))
        };
}


#endif